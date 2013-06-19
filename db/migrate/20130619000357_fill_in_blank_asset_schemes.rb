class FillInBlankAssetSchemes < ActiveRecord::Migration
  def up
    update_asset_scheme(BlogEntry, :blog_asset_scheme, "wide")
    update_asset_scheme(ShowSegment, :segment_asset_scheme, "wide")
    update_asset_scheme(NewsStory, :story_asset_scheme, "float")
    update_asset_scheme(NewsStory, :extra_asset_scheme, "hidden")
    update_asset_scheme(Event, :event_asset_scheme, "wide")


    BlogEntry.where("blog_asset_scheme = ?", 'right').find_each do |obj|
      obj.update_column(:blog_asset_scheme, "float")
    end
  end

  def down
  end


  private

  def update_asset_scheme(klass, column, scheme)
    klass.where("#{column} = ? or #{column} is null", '').find_each do |obj|
      if asset = obj.asset
        obj.update_column(column, scheme)
      end
    end
  end
end
