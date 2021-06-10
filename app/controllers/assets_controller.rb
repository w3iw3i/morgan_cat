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

  def update
  end

  private

  def asset_params
    params.require(:asset).permit(:asset_type, :amount, :growth_rate, :asset_allocation)
  end

end
