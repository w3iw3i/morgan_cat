class AddAssetAllocationToAssets < ActiveRecord::Migration[6.1]
  def change
    add_column :assets, :asset_allocation, :integer
  end
end
