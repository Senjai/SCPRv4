class ContentCategory < ActiveRecord::Base
  self.table_name =  'contentbase_contentcategory'
  belongs_to :content, polymorphic: true
end

class MigrateCategoryIds < ActiveRecord::Migration
  def up
    [BlogEntry, NewsStory, ShowSegment, ContentShell, VideoShell].each do |model|
      $stdout.puts "Migrating category_id for #{model}"
      model.has_one :content_category, as: :content
      
      model.find_each do |record|
        if category_id = record.content_category.try(:category_id)
          record.update_column(:category_id, category_id)
        end
      end
    end
  end

  def down
  end
end
