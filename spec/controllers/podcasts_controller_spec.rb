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
    
    it "redirects to podcast_url if source is ExternalProgram" do
      program = create :external_program, :from_rss
      podcast = create :podcast, source: program
      get :podcast, slug: podcast.slug
      response.should redirect_to podcast.podcast_url
    end
    
    context "sphinx search" do
      before :all do
        setup_sphinx
      end

      after :all do
        teardown_sphinx
      end

      it "assigns the content for entry" do
        entry   = create :blog_entry
        audio   = create :audio, :uploaded, content: entry

        entry.reload

        index_sphinx

        podcast = create :podcast, slug: "podcast", source: entry.blog

        ts_retry(2) do
          get :podcast, slug: "podcast"
          assigns(:articles).should eq [entry.to_article]
        end

        purge_uploaded_audio
      end

      it "assigns the content for episode" do
        episode   = create :show_episode
        audio     = create :audio, :uploaded, content: episode

        index_sphinx

        podcast = create :podcast, slug: "podcast", source: episode.show, item_type: "episodes"

        ts_retry(2) do
          get :podcast, slug: "podcast"
          assigns(:articles).should eq [episode.to_article]
        end

        purge_uploaded_audio
      end
    end
  end
end
