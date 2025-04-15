class ProductsController < InheritedResources::Base
  before_action :load_categories, only: [:index]

  def index
    @products = Product.all

    # 🔍 Keyword Search
    if params[:search].present?
      keyword = "%#{params[:search]}%"
      @products = @products.where("name ILIKE ? OR description ILIKE ?", keyword, keyword)
    end

    # 📂 Category Filter
    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end

    # 🎯 Special Filters
    case params[:filter]
    when "new"
      @products = @products.where("created_at >= ?", 3.days.ago)
    when "on_sale"
      @products = @products.where("price < ?", 100)
    when "recently_updated"
      @products = @products.where("updated_at >= ? AND created_at < ?", 3.days.ago, 3.days.ago)
    end

    # 📄 Pagination
    @products = @products.page(params[:page]).per(12)
  end

  private

  def load_categories
    @categories = Category.all
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :stock_quantity, :image, :category_id)
  end
end
