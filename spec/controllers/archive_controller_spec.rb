require "spec_helper"

describe ArchiveController do
  render_views
  
  describe "POST /process" do
    it "redirects to archive_path with the processed date" do
      post :process_form, 
        archive: { "date(1i)" => "2012", "date(2i)" => "4", "date(3i)" => "1" }
      response.should redirect_to archive_path("2012", "04", "01")
    end
  end
  
  #---------------
  
  describe "GET /show" do
    it "doesn't assign date if none requested" do
      get :show
      assigns(:date).should be_nil
    end
    
    it "assigns date to requested date" do
      get :show, date_path(Time.now.yesterday.beginning_of_day)
      assigns(:date).should eq Time.now.yesterday.beginning_of_day
    end
    
    it "date is a Time object" do
      get :show, date_path(Time.now.yesterday.beginning_of_day)
      assigns(:date).should be_a Time
    end

    it "doesn't assign @date if requested date is in the future" do
      get :show, date_path(Time.now.tomorrow)
      assigns(:date).should be_nil
    end
    
    it "raises 404 if requested date is today" do
      get :show, date_path(Time.now.to_date)
      assigns(:date).should be_nil
    end
    
    %w{ news_story show_segment blog_entry content_shell }.each do |content|
      it "only gets #{content.pluralize} published on requested date" do
        # Stub `publishing?` so the published_at date doesn't get updated
        stub_publishing_callbacks(content.classify.constantize)
        
        yesterday = create content.to_sym, published_at: Time.now.yesterday
        today     = create content.to_sym, published_at: Time.now
        tomorrow  = create content.to_sym, published_at: Time.now.tomorrow
        
        get :show, date_path(Time.now.yesterday)
        assigns(:date).should be_present
        assigns(content.pluralize.to_sym).should eq [yesterday]
      end
    end
    
    it "only gets show episodes published on requested date" do
      yesterday = create :show_episode, air_date: Time.now.yesterday
      today     = create :show_episode, air_date: Time.now
      tomorrow  = create :show_episode, air_date: Time.now.tomorrow
      get :show, date_path(Time.now.yesterday.beginning_of_day)
      assigns(:show_episodes).should eq [yesterday]
    end
  end
end
