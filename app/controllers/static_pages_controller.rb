class StaticPagesController < InheritedResources::Base

  private

    def static_page_params
      params.require(:static_page).permit(:title, :content, :slug)
    end

end


class StaticPagesController < ApplicationController
  def show
    @page = StaticPage.find_by(slug: params[:id])
  end
end
