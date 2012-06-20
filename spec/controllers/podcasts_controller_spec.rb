require "spec_helper"

describe PodcastsController do
  describe "GET /index" do
    it "orders by title asc" do
      get :index
      assigns(:podcasts).to_sql.should match /order by title asc/i
    end
    
    it "only shows listed" do
      unlisted = create :podcast, is_listed: false
      listed = create :podcast, is_listed: true
      get :index
      assigns(:podcasts).should eq [listed]
    end
  end
  
  describe "GET /podcasts/:slug" do
    it "returns 404 if no podcast is found" do
      get :podcast, slug: "nonsense"
      response.should be_not_found
    end
  end
end
