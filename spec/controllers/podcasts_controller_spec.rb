require "spec_helper"

describe PodcastsController do
  render_views
  
  describe "GET /index" do
    it "orders by title asc" do
      get :index
      assigns(:podcasts).to_sql.should match /order by title/i
    end
    
    it "only shows listed" do
      unlisted = create :podcast, is_listed: false
      listed   = create :podcast, is_listed: true
      get :index
      assigns(:podcasts).should eq [listed]
    end
  end
  
  #---------------

  describe "GET /podcast" do    
    it "finds the correct podcast" do
      podcast = create :podcast, slug: "podcast"

      ThinkingSphinx::Test.run do
        get :podcast, slug: "podcast"
        assigns(:podcast).should eq podcast
      end
    end
    
    context "sphinx search" do
      before :all do
        setup_sphinx
      end
      
      before :each do
        @entry = create :blog_entry
        audio = create :audio, :uploaded
        @entry.audio.push audio
        @entry.save!
      end
      
      after :all do
        teardown_sphinx
      end
      
      it "assigns the content" do
        podcast = create :podcast, slug: "podcast", source: @entry.blog
        
        ThinkingSphinx::Test.run do
          get :podcast, slug: "podcast"
          assigns(:content).should eq [@entry]
        end
      end
    end
  end
  
  #---------------
  
  describe "GET /podcasts/:slug" do
    it "returns RecordNotFound if no podcast is found" do
      -> { 
        get :podcast, slug: "nonsense"
      }.should raise_error ActiveRecord::RecordNotFound
    end
  end
end
