class RemoveLeadAssetSchemeFromNewsStories < ActiveRecord::Migration
  def up
    remove_column :news_story, :lead_asset_scheme
  end

  def down
    add_column :news_story, :lead_asset_scheme, :string
  end
end
