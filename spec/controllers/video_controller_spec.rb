require "spec_helper"

describe VideoController do
  render_views
  
  describe "GET /index" do
    it "finds the most recently published video" do
      published_recent = create :video_shell, :published, published_at: 1.hour.ago
      published_old    = create :video_shell, :published, published_at: 2.hours.ago
      pending          = create :video_shell, :pending, published_at: Time.now
      get :index
      assigns(:video).should eq published_recent
    end
    
    it "is fine if no video is found" do
      get :index
      response.should be_success
    end
  end
  
  #------------------

  describe "GET /show" do
    it "assigns video to param id" do
      video = create :video_shell, :published
      get :show, slug: video.slug, id: video.id
      assigns(:video).should eq video
    end
    
    it "raises a RecordNotFound if video not found" do
      -> { 
        get :show, slug: "nonsense", id: "9999"
      }.should raise_error ActiveRecord::RecordNotFound
    end
  end

  #------------------
  
  describe "GET /list" do
    it "assigns videos to published videos" do
      pub_videos   = create_list :video_shell, 3, :published
      unpub_videos = create_list :video_shell, 3, :pending
      get :list
      assigns(:videos).sort.should eq pub_videos.sort
    end
    
    it "paginates" do
      videos = create_list :video_shell, 10, :published
      get :list, page: 2
      assigns(:videos).size.should eq 1
    end
  end
  
  #------------------
  
  describe "get_latest_videos" do
    it "gets latest videos" do
      published_recent = create :video_shell, :published, published_at: 1.hour.ago
      published_old    = create :video_shell, :published, published_at: 2.hours.ago
      get :index
      assigns(:latest_videos).should eq [published_old]
    end
  end
end
