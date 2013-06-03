require "spec_helper"

describe Api::Public::V2::AudioController do
  request_params = {
    :format => :json
  }

  render_views

  describe "GET show" do
    it "finds the object if it exists" do
      purge_uploaded_audio

      audio = create :uploaded_audio
      get :show, { id: audio.id }.merge(request_params)
      assigns(:audio).should eq audio
      response.should render_template "show"
    end

    it "returns a 404 status if it does not exist" do
      get :show, { id: "99" }.merge(request_params)
      response.response_code.should eq 404
      response.body.should eq Hash[error: "Not Found"].to_json
    end
  end


  describe "GET index" do
    before :each do
      purge_uploaded_audio

      @available   = []
      3.times { |n| @available << create(:uploaded_audio, mp3: load_audio_fixture("audio/point1sec-#{n}.mp3")) }
      @unavailable = create_list :enco_audio, 2
    end

    it "sanitizes the limit" do
      get :index, { limit: "Evil Code" }.merge(request_params)
      assigns(:limit).should eq 0
      assigns(:audio).should eq @available.sort_by(&:created_at) # Why? Should have to be reversed. Microseconds or something.
    end

    it "accepts a limit" do
      get :index, { limit: 1 }.merge(request_params)
      assigns(:audio).size.should eq 1
    end

    it "sets the max limit to 40" do
        get :index, { limit: 100 }.merge(request_params)
        assigns(:limit).should eq 40
    end

    it "sanitizes the page" do
      get :index, { page: "Evil Code" }.merge(request_params)
      assigns(:page).should eq 1
      assigns(:audio).size.should eq @available.size
    end

    it "accepts a page" do
      get :index, request_params
      third_obj = assigns(:audio)[2]

      get :index, { page: 3, limit: 1 }.merge(request_params)
      assigns(:audio).should eq [third_obj]
    end

    it "only gets available audio" do
      get :index, request_params
      (assigns(:audio) & @unavailable).should eq []
    end
  end
end
