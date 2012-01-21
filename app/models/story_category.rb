class StoryCategory < ActiveRecord::Base
  self.table_name =  'news_storycategories'
  
  belongs_to :story, :class_name => "NewsStory"
  belongs_to :category, :class_name => "Category"
end