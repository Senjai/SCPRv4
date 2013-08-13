require "spec_helper"

describe Api::Public::V3::EventsController do
  request_params = {
    :format => :json
  }

  render_views

  describe "GET show" do
    it "finds the object if it exists" do
      event = create :event, :published,
        kpcc_program: create(:kpcc_program),
        archive_description: "blahblabhalh"

      get :show, { id: event.id }.merge(request_params)
      assigns(:event).should eq event
      response.should render_template "show"
    end

    it "returns a 404 status if it does not exist" do
      get :show, { id: 999 }.merge(request_params)
      response.response_code.should eq 404
      response.body.should eq Hash[error: "Not Found"].to_json
    end
  end

  describe "GET index" do
    it 'only fetches published events' do
      published     = create :event, :published
      unpublished   = create :event # default status is 0 in the factory

      get :index, request_params
      assigns(:events).should eq [published]
    end

    it "sanitizes the limit" do
      create :event, :published
      get :index, { limit: "Evil Code" }.merge(request_params)
      assigns(:limit).should eq 0
      assigns(:events).should eq Event.all
    end

    it "accepts a limit" do
      create_list :event, 2, :published
      get :index, { limit: 1 }.merge(request_params)
      assigns(:events).size.should eq 1
    end

    it "sets the max limit to 40" do
      get :index, { limit: 100 }.merge(request_params)
      assigns(:limit).should eq 40
    end

    it "sanitizes the page" do
      event = create :event, :published
      get :index, { page: "Evil Code" }.merge(request_params)
      assigns(:page).should eq 1
      assigns(:events).should eq [event]
    end

    it "accepts a page" do
      create_list :event, 3, :published
      get :index, request_params
      second = assigns(:events)[1]

      get :index, { page: 2, limit: 1 }.merge(request_params)
      assigns(:events).should eq [second]
    end

    it 'only returns requested types' do
      spon = create :event, :published, event_type: "spon"
      comm = create :event, :published, event_type: "comm"
      hall = create :event, :published, event_type: "hall"

      get :index, { types: "comm,hall" }.merge(request_params)
      assigns(:events).sort.should eq [comm, hall].sort
    end

    it 'does not care about type if none are specified' do
      spon = create :event, :published, event_type: "spon"
      comm = create :event, :published, event_type: "comm"
      hall = create :event, :published, event_type: "hall"

      get :index, request_params
      assigns(:events).sort.should eq [spon, comm, hall].sort
    end

    it 'only returns kpcc events if requested' do
      kpcc_event      = create :event, :published, is_kpcc_event: true
      non_kpcc_event  = create :event, :published, is_kpcc_event: false

      get :index, { only_kpcc_events: "true" }.merge(request_params)
      assigns(:events).should eq [kpcc_event]
    end

    it 'does not care about is_kpcc_event if not specified' do
      kpcc_event      = create :event, :published, is_kpcc_event: true
      non_kpcc_event  = create :event, :published, is_kpcc_event: false

      get :index, request_params
      assigns(:events).sort.should eq [kpcc_event, non_kpcc_event].sort
    end

    describe 'date filtering' do
      before :each do
        Time.stub(:now) { Time.new(2013, 6, 14) }
        
        @way_past     = create :event, :published, starts_at: Time.new(2012, 6, 8)
        @past         = create :event, :published, starts_at: Time.new(2013, 6, 8)
        @future       = create :event, :published, starts_at: Time.new(2013, 6, 20)
        @way_future   = create :event, :published, starts_at: Time.new(2014, 6, 20)
      end

      it 'filters by start_date if only it is specified' do
        get :index, { start_date: "2013-06-12" }.merge(request_params)
        assigns(:events).should eq [@future, @way_future]
      end

      it 'filters by specified start and end dates if both specified' do
        get :index, { start_date: "2013-06-12", end_date: "2013-07-12" }.merge(request_params)
        assigns(:events).should eq [@future]
      end

      it 'filters now to end_date if only end_date is specified and is future' do
        get :index, { end_date: "2013-06-22" }.merge(request_params)
        assigns(:events).should eq [@future]
      end

      it 'filters beginning of time to end_date if only end_date is specified and is past' do
        get :index, { end_date: "2013-06-10" }.merge(request_params)
        assigns(:events).should eq [@way_past, @past]
      end

      it 'filters now to end of time if no dates specified' do
        get :index, request_params
        assigns(:events).should eq [@future, @way_future]
      end
    end
  end
end
