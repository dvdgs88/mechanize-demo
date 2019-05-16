class ProductsController < ApplicationController

  PRODUCTS = {
    alexa: 'B0792HCFTG',
    nintendo_switch: 'B01N5OPMJW',
    battlefield_5: 'B07D87SQ67'
  }.freeze

  def index
    @products = scrap_products
    puts @products
  end

  private

  def scrap_products
    [].tap do |products|
      PRODUCTS.each do |k, v|
        products << Scrappers::AmazonProductFinder.new(v).call
      end
    end
  end

end
