require "spec_helper"

describe NewsController do
  render_views
  
  describe "GET /story" do
    it "assigns @story" do
      story = create :news_story, :published
      get :story, { id: story.id, slug: story.slug }.merge!(date_path(story.published_at))
      assigns(:story).should eq story
    end
    
    it "raises RecordNotFound if story not found" do
      story = create :news_story, :published
      -> {
        get :story, { id: "999999", slug: story.slug }.merge!(date_path(story.published_at))
      }.should raise_error ActiveRecord::RecordNotFound
    end
  end
end
