class AddContentAssetView < ActiveRecord::Migration
  def up
    execute("
      create view rails_assethost_contentasset as 
      select 
        a.id,
        a.object_id as content_id,
        m.class_name as content_type,
        asset_order,asset_id,
        caption 
      from 
        assethost_contentasset as a, 
        rails_content_map as m 
      where a.content_type_id = m.id
    ")
  end

  def down
    execute("drop view rails_assethost_contentasset")
  end
end
