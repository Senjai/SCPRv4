require "spec_helper"

describe EventsController do
  describe "GET /index" do
    it "assigns @events using upcoming_and_current scope" do
      past    = create :event, :past
      current = create :event, :current
      future  = create :event, :future
      get :index
      assigns(:events).should eq [current, future]
    end
    
    describe "scoping" do
      before :each do
        @forum = create :event, :future, etype: "comm"
        @spon = create :event, :future, etype: "spon"
      end
      
      it "scopes by forum if requested" do
        get :index, list: "forum"
        assigns(:scoped_events).should eq [@forum]
      end

      it "scoped by sponsored if requested" do
        get :index, list: "sponsored"
        assigns(:scoped_events).should eq [@spon]
      end

      it "does not scope by etype if nothing requested" do
        get :index
        scoped_events = assigns(:scoped_events)
        scoped_events.should include @forum
        scoped_events.should include @spon
      end
    end
  end
  
  describe "GET /forum" do
    it "assigns @upcoming_events using upcoming_and_current scope" do
      past_event = create :event, starts_at: 2.hours.ago, ends_at: 1.hour.ago, etype: 'comm'
      current_event = create :event, starts_at: 2.hours.ago, ends_at: 2.hours.from_now, etype: 'comm'
      future_event = create :event, starts_at: 2.hours.from_now, ends_at: 3.hours.from_now, etype: 'comm'
      get :forum
      assigns(:upcoming_events).should eq [current_event,future_event]
    end
    
  end
end
