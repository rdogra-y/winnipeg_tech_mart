module BreadcrumbsHelper
  def render_breadcrumbs
    parts = request.path.split('/').reject(&:blank?)
    crumbs = []
    crumbs << link_to('Home', root_path)

    if request.path.match?(/^\/products\/\d+$/)
      # Example: /products/154
      product = Product.find_by(id: parts.last)
      if product
        category = product.category
        crumbs << link_to(category.name, category_path(category)) if category
        crumbs << content_tag(:span, product.name)
      else
        crumbs << content_tag(:span, "Product ##{parts.last}")
      end

    elsif request.path.match?(/^\/categories\/\d+$/)
      # Example: /categories/8
      category = Category.find_by(id: parts.last)
      crumbs << content_tag(:span, category&.name || "Category ##{parts.last}")

    elsif request.path.match?(/^\/orders\/\d+$/)
      # Example: /orders/70
      crumbs << link_to("Orders", orders_path)
      crumbs << content_tag(:span, "Order ##{parts.last}")

    else
      # Fallback for other paths
      parts.each_with_index do |part, index|
        path = '/' + parts[0..index].join('/')
        if index == parts.length - 1
          crumbs << content_tag(:span, part.titleize.gsub('-', ' '))
        else
          crumbs << link_to(part.titleize.gsub('-', ' '), path)
        end
      end
    end

    safe_join(crumbs, ' > '.html_safe)
  end
end
