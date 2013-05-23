class MigrateEventAssetSchemes < ActiveRecord::Migration
  def up
    Event.where(event_asset_scheme: "wide").each do |event|
      if event.assets.present?
        if event.assets.first.asset.native.present?
          event.update_attribute(:event_asset_scheme, "video")
        end
      end
    end
  end

  def down
    Event.where(event_asset_scheme: "video").each do |event|
      event.update_attribute(:event_asset_scheme, "wide")
    end
  end
end
