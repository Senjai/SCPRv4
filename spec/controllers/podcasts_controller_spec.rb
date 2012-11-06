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
    it "returns RecordNotFound if no podcast is found" do
      -> { 
        get :podcast, slug: "nonsense"
      }.should raise_error ActiveRecord::RecordNotFound
    end
    
    it "finds the correct podcast" do
      podcast = create :podcast, slug: "podcast"
      Podcast.any_instance.stub(:content) { [] }
      get :podcast, slug: "podcast"
      assigns(:podcast).should eq podcast
    end
    
    context "sphinx search" do
      it "assigns the content" do
        entry = create :blog_entry
        audio = create :audio, :uploaded
        entry.audio.push audio
        entry.save!
        
        podcast = create :podcast, slug: "podcast", source: entry.blog
        
        Podcast.any_instance.should_receive(:content).and_return([entry])
        get :podcast, slug: "podcast"
        assigns(:content).should eq [entry]
      end
    end
  end
end
