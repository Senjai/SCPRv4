require 'spec_helper'

describe Api::Public::V2::ScheduleOccurrencesController do
  request_params = {
    :format => :json
  }

  render_views

  describe 'GET /index' do
    it "returns this week's schedule by default" do
      occurrence1 = create :schedule_occurrence, starts_at: Time.now
      occurrence2 = create :schedule_occurrence, starts_at: Time.now.end_of_week

      get :index, request_params
      assigns(:schedule_occurrences).should eq [occurrence1, occurrence2]
    end

    it "uses the given start_time" do
      occurrence1 = create :schedule_occurrence, starts_at: Time.now
      occurrence2 = create :schedule_occurrence, starts_at: Time.now + 3.hours

      get :index, { start_time: (Time.now + 1.hour).to_i }.merge(request_params)
      assigns(:schedule_occurrences).should eq [occurrence2]
    end

    it "uses the given length" do
      occurrence1 = create :schedule_occurrence, starts_at: Time.now
      occurrence2 = create :schedule_occurrence, starts_at: Time.now + 3.hours

      get :index, { start_time: (Time.now - 1.hour).to_i, length: 2.hours }.merge(request_params)
      assigns(:schedule_occurrences).should eq [occurrence1]
    end

    it "returns error if start_time past a month from now" do
      get :index, { start_time: (Time.now + 1.month + 1.day).to_i }.merge(request_params)
      response.body.should match /error/
    end
  end

  describe 'GET /show' do
    it "returns the schedule occurrence on at the requested time" do
      occurrence1 = create :schedule_occurrence, starts_at: 10.minutes.ago

      get :show, { at: Time.now.to_i }.merge(request_params)
      assigns(:schedule_occurrence).should eq occurrence1
    end

    it 'is an empty object if nothing is on' do
      get :show, request_params
      response.body.should eq "{}"
    end

    it "returns error if time past a month from now" do
      get :show, { time: (Time.now + 1.month + 1.day).to_i }.merge(request_params)
      response.body.should match /error/
    end
  end
end
