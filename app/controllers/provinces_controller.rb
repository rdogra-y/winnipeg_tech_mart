class ProvincesController < ApplicationController
  before_action :require_admin

  def index
    @provinces = Province.all
  end

  def edit
    @province = Province.find(params[:id])
  end

  def update
    @province = Province.find(params[:id])
    if @province.update(province_params)
      redirect_to provinces_path, notice: "Tax rates updated successfully."
    else
      render :edit, alert: "Update failed."
    end
  end

  private

  def require_admin
    redirect_to root_path, alert: "Unauthorized access" unless current_user&.admin?
  end

  def province_params
    params.require(:province).permit(:name, :gst, :pst, :hst)
  end
end
