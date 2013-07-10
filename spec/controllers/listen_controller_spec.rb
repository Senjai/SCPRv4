require "spec_helper"

describe ListenController do
  render_views

  describe "GET /index" do
    it "gets schedule for the next 8 hours" do
      t = Time.now - 1.hour
      slot1 = create :schedule_occurrence, starts_at: t, ends_at: t + 2.hours
      slot2 = create :schedule_occurrence, starts_at: t+2.hours, ends_at: t + 4.hours

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
