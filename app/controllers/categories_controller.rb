class CategoriesController < ApplicationController
  layout "application"
  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
    @products = @category.products.page(params[:page]).per(12)
  end

  private

  def category_params
    params.require(:category).permit(:name, :description)
  end
end
