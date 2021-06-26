class AssetsController < ApplicationController
  def index
    @asset = Asset.new
    @my_asset = Asset.where(user: current_user)
    update_cash_allocation
    @current_asset_array = []
    @my_asset.each do |asset|
      @current_asset_array << asset.asset_type
    end
    @all_asset_types = ["Cash", "Stock", "Bond", "CPF-O", "CPF-M", "CPF-S"]
    @remaining_asset_types = @all_asset_types - @current_asset_array
  end

  def create
    @asset = Asset.new(asset_params)
    @asset.user = current_user
    if @asset.save
      update_cash_allocation
      redirect_to assets_path
    end
  end

  def destroy
    @asset = Asset.find(params[:id])
    @asset.destroy
    update_cash_allocation
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

  def update_cash_allocation
    @other_asset_sum = 0
    @other_assets = Asset.where(user_id: current_user.id).where.not(asset_type: "Cash")
    @other_assets.each do |other_asset|
      @other_asset_sum += other_asset.asset_allocation
    end

    @cash = Asset.where(user_id: current_user.id, asset_type: "Cash")
    @cash.update(asset_allocation: (80 - @other_asset_sum))
  end

end
