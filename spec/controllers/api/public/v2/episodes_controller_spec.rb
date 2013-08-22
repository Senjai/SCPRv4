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
      assigns(:episode).should eq episode.to_episode
      response.should render_template "show"
    end

    it "returns a 404 status if it does not exist" do
      get :show, { id: 999 }.merge(request_params)
      response.response_code.should eq 404
      response.body.should eq Hash[error: "Not Found"].to_json
    end
  end

  describe "GET index" do
    it 'gets the episodes from a program if it is given' do
      episode1 = create :external_episode
      episode2 = create :external_episode

      get :index, { program: episode1.external_program.slug }.merge(request_params)
      assigns(:episodes).should eq [episode1].map(&:to_episode)
    end

    it 'uses the segments if the program uses_segments_as_episodes? is true' do
      program = create :kpcc_program, display_segments: true, display_episodes: false
      segment = create :show_segment, show: program

      get :index, { program: program.slug }.merge(request_params)
      assigns(:episodes).should eq [segment].map(&:to_episode)
    end

    it "returns the latest KPCC episodes by default" do
      kpcc_episodes       = create_list :show_episode, 2
      external_episodes   = create_list :external_episode, 2

      get :index, request_params
      assigns(:episodes).should eq kpcc_episodes.sort_by(&:air_date).reverse.map(&:to_episode)
    end

    it "only gets published episodes" do
      published   = create :show_episode, :published
      unpublished = create :show_episode, :draft

      get :index, request_params
      assigns(:episodes).should eq [published].map(&:to_episode)
    end

    it 'can filter by program slug' do
      program1 = create :kpcc_program, :episodic, slug: 'hello'
      program2 = create :kpcc_program, :episodic,  slug: 'goodbye'

      episode1 = create :show_episode, show: program1
      episode2 = create :show_episode, show: program2

      get :index, { program: program1.slug }.merge(request_params)
      assigns(:episodes).should eq [episode1].map(&:to_episode)
    end

    it 'sorts the episodes by descending air_date for kpcc programs' do
      program   = create :kpcc_program, display_segments: false, display_episodes: true
      episode2  = create :show_episode, show: program, air_date: Time.now.yesterday
      episode1  = create :show_episode, show: program, air_date: Time.now.tomorrow

      get :index, { program: program.slug }.merge(request_params)
      assigns(:episodes).should eq [episode1, episode2].map(&:to_episode)
    end

    it 'sorts the episodes by descending air_date for external programs' do
      program   = create :external_program
      episode2  = create :external_episode, external_program: program, air_date: Time.now.yesterday
      episode1  = create :external_episode, external_program: program, air_date: Time.now.tomorrow

      get :index, { program: program.slug }.merge(request_params)
      assigns(:episodes).should eq [episode1, episode2].map(&:to_episode)
    end

    it 'returns a 404 if the program is not found' do
      get :index, { program: "lolnope" }.merge(request_params)
      response.response_code.should eq 404
    end

    it 'can filter by air date' do
      episode1 = create :show_episode, air_date: Time.new(2013, 6, 25)
      episode2 = create :show_episode, air_date: Time.new(2013, 6, 24)

      get :index, { air_date: "2013-06-24" }.merge(request_params)
      assigns(:episodes).should eq [episode2].map(&:to_episode)
    end

    it 'can filter by air date for external programs' do
      program = create :external_program
      episode1 = create :external_episode, air_date: Time.new(2013, 6, 25), external_program: program
      episode2 = create :external_episode, air_date: Time.new(2013, 6, 25), external_program: program

      get :index, { program: program.slug, air_date: "2013-06-25" }.merge(request_params)
      assigns(:episodes).should eq [episode1, episode2].map(&:to_episode)
    end

    it 'can filter by air date for segmented programs' do
      program = create :kpcc_program, display_segments: true, display_episodes: false
      segment = create :show_segment, show: program, published_at: Time.new(2013, 6, 25)

      get :index, { program: program.slug, air_date: "2013-06-25" }.merge(request_params)
      assigns(:episodes).should eq [segment].map(&:to_episode)
    end

    it "sanitizes the limit" do
      episodes = create_list :show_episode, 1
      get :index, { limit: "Evil Code" }.merge(request_params)

      assigns(:limit).should eq 0
      assigns(:episodes).should eq episodes.map(&:to_episode)
    end

    it "accepts a limit" do
      create_list :show_episode, 2, :published
      get :index, { limit: 1 }.merge(request_params)
      assigns(:episodes).size.should eq 1
    end

    it "sets the max limit to 8" do
      get :index, { limit: 100 }.merge(request_params)
      assigns(:limit).should eq 8
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
      assigns(:episodes).should eq [second_obj].map(&:to_episode)
    end
  end
end
