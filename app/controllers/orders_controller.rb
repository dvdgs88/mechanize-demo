class OrdersController < ApplicationController

  def index
    @orders = scrap_orders
    puts @orders
  end

  private

  def scrap_orders
    Scrappers::AmazonOrdersFinder.new.call
  end
end