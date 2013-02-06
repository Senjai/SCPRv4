require "spec_helper"

describe Admin::NewsStoriesController do
  it_behaves_like "resource controller" do
    let(:resource) { :news_story }
  end

  describe "preview" do
    render_views 
    
    before :each do
      @admin_user = create :admin_user
      controller.stub(:admin_user) { @admin_user }
    end
    
    context "existing object" do
      it "builds the object from existing attributes and assigns new ones" do
        news_story = create :news_story, headline: "This is a story"
        put :preview, id: news_story.id, obj_key: news_story.obj_key, news_story: news_story.attributes.merge(headline: "Updated")
        assigns(:story).should eq news_story
        assigns(:story).headline.should eq "Updated"
        response.should render_template "/news/_story"
      end

      it "renders validation errors if the object is not unconditionally valid" do
        news_story = create :news_story, headline: "Okay"
        put :preview, id: news_story.id, obj_key: news_story.obj_key, news_story: news_story.attributes.merge(headline: "")
        response.should render_template "/admin/shared/_preview_errors"
      end
    end

    context "new object" do
      it "builds a new object and assigns the attributes" do
        news_story = build :news_story, headline: "This is a story"
        post :preview, obj_key: news_story.obj_key, news_story: news_story.attributes
        assigns(:story).headline.should eq "This is a story"
        response.should render_template "/news/_story"
      end

      it "renders validation errors if the object is not unconditionally valid" do
        news_story = build :news_story, headline: "okay"
        post :preview, obj_key: news_story.obj_key, news_story: news_story.attributes.merge(headline: "")
        response.should render_template "/admin/shared/_preview_errors"
      end
    end
  end
end
