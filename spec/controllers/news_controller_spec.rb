require "spec_helper"

describe NewsController do
  describe "GET /story" do
    context 'view' do
      render_views

      it 'renders the view' do
        story   = create :news_story
        bio     = create :bio, twitter_handle: "bryanricker"
        byline  = create :byline, content: story, user: bio

        get :story, story.route_hash
      end
    end

    context 'controller' do
      it "assigns @story" do
        story = create :news_story, :published
        get :story, story.route_hash
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
end
