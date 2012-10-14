require "spec_helper"

describe NewsController do
  render_views
  
  describe "GET /story" do
    it "assigns @story" do
      story = create :news_story
      get :story, { id: story.id, slug: story.slug }.merge!(date_path(story.published_at))
      assigns(:story).should eq story
    end
    
    it "raises RecordNotFound if story not found" do
      story = create :news_story
      -> {
        get :story, { id: "999999", slug: story.slug }.merge!(date_path(story.published_at))
      }.should raise_error ActiveRecord::RecordNotFound
    end
  end
  
  describe "GET /old_story" do
    it "redirects to correct URL if story is found" do
      story = create :news_story
      get :old_story, { slug: story.slug }.merge!(date_path(story.published_at))
      response.should redirect_to story.link_path
    end
    
    it "only looks at published stories" do
      story = create :news_story, :pending
      -> {
        get :old_story, { slug: story.slug }.merge!(date_path(story.published_at))
      }.should raise_error ActiveRecord::RecordNotFound
    end
  end
end
