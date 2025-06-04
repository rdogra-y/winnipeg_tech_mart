class StaticPagesController < ApplicationController
  layout "application"
  def show
    @page = StaticPage.find_by(slug: params[:slug])
    if @page.nil?
      render file: "#{Rails.root}/public/404.html", status: :not_found
    end
  end
end
