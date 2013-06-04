class RenameAssetOrderToPosition < ActiveRecord::Migration
  def up
    rename_column :assethost_contentasset, :asset_order, :position
  end

  def down
    rename_column :assethost_contentasset, :position, :asset_order
  end
end
