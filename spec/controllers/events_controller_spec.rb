require "spec_helper"

describe EventsController do
  describe "GET /index" do
    it "assigns @events using upcoming_and_current scope" do
      past_event = create :event, starts_at: 2.hours.ago, ends_at: 1.hour.ago
      current_event = create :event, starts_at: 2.hours.ago, ends_at: 2.hours.from_now
      future_event = create :event, starts_at: 2.hours.from_now, ends_at: 3.hours.from_now
      get :index
      assigns(:events).should eq [current_event,future_event]
    end
    
    it "orders by start_date" do
      get :index
      assigns(:events).to_sql.should match /order by starts_at/i
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
