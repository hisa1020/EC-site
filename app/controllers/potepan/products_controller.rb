module Potepan
  class ProductsController < ApplicationController
    MAX_RELATED_PRODUCTS_COUNT = 4

    def show
      @product = Spree::Product.find(params[:id])
      @related_products =
        @product.related_products.
          includes(master: [:images, :default_price]).
          limit(MAX_RELATED_PRODUCTS_COUNT)
    end
  end
end
