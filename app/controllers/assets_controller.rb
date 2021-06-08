class AssetsController < ApplicationController
  def index
    # @assets = Asset.all
    @asset = Asset.new
  end

  def create
    Asset.new(??)
  end

  def update
  end

  private

  def asset_params
    #TODO:
    params.require
  end

end
