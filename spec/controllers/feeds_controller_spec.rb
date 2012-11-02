require "spec_helper"

describe FeedsController do  
  describe "GET /all_news" do
    sphinx_spec(num: 1)
    
    it "doesn't render a layout" do
      ThinkingSphinx::Test.run do
        get :all_news
        response.should render_template(layout: false)
      end
    end
    
    it "adds XML content-type to header" do
      ThinkingSphinx::Test.run do
        get :all_news
        response.header["Content-Type"].should eq "text/xml"
      end
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
        ThinkingSphinx::Test.run do
          get :all_news
          response.body.should be_a String
        end
      end
    
      it "writes to cache" do
        ThinkingSphinx::Test.run do
          Rails.cache.should_receive(:write_entry)
          get :all_news
        end
      end
      
      it "uses sphinx to populate @content" do
        ThinkingSphinx::Test.run do
          get :all_news
          assigns(:content).should_not be_blank
        end
      end
    end
  end
end
