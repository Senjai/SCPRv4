require "spec_helper"

describe Api::Public::V2::EpisodesController do
  request_params = {
    :format => :json
  }

  render_views

  describe "GET show" do
    it "finds the object if it exists" do
      episode = create :show_episode
      get :show, { id: episode.id }.merge(request_params)
      assigns(:episode).should eq episode
      response.should render_template "show"
    end

    it "returns a 404 status if it does not exist" do
      get :show, { id: 999 }.merge(request_params)
      response.response_code.should eq 404
      response.body.should eq Hash[error: "Not Found"].to_json
    end
  end

  describe "GET index" do
    it "returns the latest episodes by default" do
      episodes = create_list :show_episode, 4
      get :index, request_params
      assigns(:episodes).should eq episodes.sort_by(&:air_date).reverse
    end

    it "only gets published episodes" do
      published = create :show_episode, :published
      unpublished = create :show_episode, :draft

      get :index, request_params
      assigns(:episodes).should eq [published]
    end

    it 'can filter by program slug' do
      program1 = create :kpcc_program, slug: 'hello'
      program2 = create :kpcc_program, slug: 'goodbye'

      episode1 = create :show_episode, show: program1
      episode2 = create :show_episode, show: program2

      get :index, { program: "hello" }.merge(request_params)
      assigns(:episodes).should eq [episode1]
    end

    it 'can filter by air date' do
      episode1 = create :show_episode, air_date: Time.new(2013, 6, 25)
      episode2 = create :show_episode, air_date: Time.new(2013, 6, 24)

      get :index, { air_date: "2013-06-24" }.merge(request_params)
      assigns(:episodes).should eq [episode2]
    end

    it "sanitizes the limit" do
      episodes = create_list :show_episode, 1
      get :index, { limit: "Evil Code" }.merge(request_params)

      assigns(:limit).should eq 0
      assigns(:episodes).should eq episodes
    end

    it "accepts a limit" do
      create_list :show_episode, 2, :published
      get :index, { limit: 1 }.merge(request_params)
      assigns(:episodes).size.should eq 1
    end

    it "sets the max limit to 16" do
      get :index, { limit: 100 }.merge(request_params)
      assigns(:limit).should eq 16
    end

    it "sanitizes the page" do
      get :index, { page: "Evil Code" }.merge(request_params)
      assigns(:page).should eq 1
    end

    it "accepts a page" do
      create_list :show_episode, 3, :published

      get :index, request_params
      second_obj = assigns(:episodes)[1]

      get :index, { page: 2, limit: 1 }.merge(request_params)
      assigns(:episodes).should eq [second_obj]
    end
  end
end
