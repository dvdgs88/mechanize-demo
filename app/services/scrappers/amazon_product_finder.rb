module Scrappers
  class AmazonProductFinder

    def initialize(product_id)
      @product_id = product_id
    end

    def call
      @session = Mechanize.new
      @session.user_agent_alias = 'Windows IE 7' # Mechanize::AGENT_ALIASES['Windows IE 7']
      @page = @session.get(product_uri)

      result
    end

    private

    def product_uri
      "https://www.amazon.es/dp/#{@product_id}"
    end

    def result
      product = OpenStruct.new
      product.uri = uri
      product.title = title
      product.price = price

      product
    end

    def uri
      @page.uri.to_s
    end

    def title
      @page.css('#productTitle').text.strip!
    end

    def price
      @page.css('#priceblock_ourprice').text
    end

  end
end