class Dashboard::MainController < ApplicationController
  
  def index
    # fetch news stories from the last seven days with no category
    @stories = NewsStory.published.where(
      "published_at > ?", Date.today - 7
    ).joins(
      "left join rails_contentbase_contentcategory on `rails_contentbase_contentcategory`.`content_id` = `news_story`.`id` AND `rails_contentbase_contentcategory`.`content_type` = 'NewsStory'"
    ).where(
      "`rails_contentbase_contentcategory`.id is null"
    ).order("published_at desc")
  end
  
end