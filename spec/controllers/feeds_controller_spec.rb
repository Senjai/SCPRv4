require "spec_helper"

describe FeedsController do
  describe "GET /all_news" do
    
    it "doesn't render a layout" do
      get :all_news
      response.should render_template(layout: false)
    end
    
    it "adds XML content-type to header" do
      get :all_news
      response.header["Content-Type"].should eq "text/xml"
    end
    
    describe "with cache available" do
      it "short-circuits and returns cache" do
        cache_value = "Cache hit."
        Rails.cache.should_receive(:fetch).with("feeds:all_news").and_return(cache_value)
        get :all_news
        response.body.should eq cache_value
      end
    end
    
    describe "without cache available" do    
      it "returns a string" do
        get :all_news
        response.body.should be_a String
      end
    
      it "writes to cache" do
        Rails.cache.should_receive(:write_entry)
        get :all_news
      end
    
      describe "sphinx" do
        sphinx_spec(num: 2)
      
        it "uses sphinx to populate @content" do
          get :all_news
          assigns(:content).should_not be_blank
        end
      end
    end
  end
end
