class ProductsController < InheritedResources::Base

  private

    def product_params
      params.require(:product).permit(:name, :description, :price, :stock_quantity, :image, :category_id)
    end

end
