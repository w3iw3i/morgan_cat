class AssetsController < ApplicationController
  def index
    @asset = Asset.new
    @my_asset = Asset.where(user: current_user)
  end

  def create
    @asset = Asset.new(asset_params)
    @asset.user = current_user
    if @asset.save
      redirect_to assets_path
    end
  end

  def destroy
    @asset = Asset.find(params[:id])
    @asset.destroy
    redirect_to assets_path
  end

  def edit
    @asset = Asset.find(params[:id])
  end

  def update
    @asset = Asset.find(params[:id])
    @asset.update(asset_params)

    redirect_to assets_path
  end

  private

  def asset_params
    params.require(:asset).permit(:asset_type, :amount, :growth_rate, :asset_allocation)
  end

end
