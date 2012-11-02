require "spec_helper"

describe ListenController do
  render_views
  
  describe "GET /index" do
    it "assigns schedule" do
      t = Time.now.second_of_week
      slot1 = create :recurring_schedule_slot, start_time: t, end_time: t + 2.hours
      slot2 = create :recurring_schedule_slot, start_time: t+2.hours, end_time: t + 4.hours
      
      get :index
      assigns(:schedule).should eq [slot1, slot2]
    end
    
    it "assigns homepage" do
      homepage = create :homepage, :published
      get :index
      assigns(:homepage).should eq homepage
    end
  end
end
