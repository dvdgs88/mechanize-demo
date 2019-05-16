module Scrappers
  class AmazonOrdersFinder

    AMAZON_URI = 'https://www.amazon.es/gp/css/order-history'
    CREDENTIALS = {
      email: ENV['AMAZON_EMAIL'],
      password: ENV['AMAZON_PASSWORD']
    }.freeze

    def initialize; end

    def call
      @session = Mechanize.new
      @session.user_agent_alias = 'Windows IE 7' # Mechanize::AGENT_ALIASES['Windows IE 7']

      if File.exist?('cookies.yaml')
        @session.cookie_jar.load('cookies.yaml')
        @page = @session.get(AMAZON_URI)
        binding.pry
      else
        @page = @session.get(AMAZON_URI)
        @page = fill_signin_form
        @session.cookie_jar.save('cookies.yaml')
      end

      result
    end

    private

    def fill_signin_form
      form = @page.form(name: 'signIn')
      form.field_with(name: 'email').value = CREDENTIALS[:email]
      form.field_with(name: 'password').value = CREDENTIALS[:password]
      form.checkbox_with(name: 'rememberMe').check

      form.submit
    end

    def result
      products = []

      @page.css('.a-box-group').each do |order|
        order.css('.a-row > .a-link-normal').each do |product|
          line_item = OpenStruct.new
          line_item.title = title(product)
          line_item.image = image(order)

          products << line_item
        end
      end

      products
    end

    def title(product)
      product.text.strip!
    end

    def image(order)
      image_node = order.css('.item-view-left-col-inner img').last
      image_node.attribute('src').value
    end

  end
end