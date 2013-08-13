require "spec_helper"

describe Api::Public::V2::AlertsController do
  request_params = {
    :format => :json
  }

  render_views

  describe "GET show" do
    it "finds the object if it exists" do
      alert = create :breaking_news_alert, :published
      get :show, { id: alert.id }.merge(request_params)
      assigns(:alert).should eq alert
      response.should render_template "show"
    end

    it 'only returns published alerts' do
      unpublished = create :breaking_news_alert, :pending
      get :show, { id: unpublished.id }.merge(request_params)
      response.response_code.should eq 404
    end

    it "returns a 404 status if it does not exist" do
      get :show, { id: "999" }.merge(request_params)
      response.response_code.should eq 404
      response.body.should eq Hash[error: "Not Found"].to_json
    end
  end

  describe "GET index" do
    it 'only returns published alerts' do
      published   = create :breaking_news_alert, :published
      unpublished = create :breaking_news_alert, :pending

      get :index, request_params
      assigns(:alerts).should eq [published]
    end

    it "sanitizes the limit" do
      alerts = create_list :breaking_news_alert, 1, :published
      get :index, { limit: "Evil Code" }.merge(request_params)
      assigns(:limit).should eq 0
      assigns(:alerts).should eq alerts
    end

    it "accepts a limit" do
      create_list :breaking_news_alert, 2, :published
      get :index, { limit: 1 }.merge(request_params)
      assigns(:alerts).size.should eq 1
    end

    it "sets the max limit to 10" do
      get :index, { limit: 100 }.merge(request_params)
      assigns(:limit).should eq 10
    end

    it "sanitizes the page" do
      get :index, { page: "Evil Code" }.merge(request_params)
      assigns(:page).should eq 1
    end

    it "accepts a page" do
      first   = create :breaking_news_alert, :published
      second  = create :breaking_news_alert, :published
      third   = create :breaking_news_alert, :published

      second.update_column(:created_at, 1.day.from_now)
      third.update_column(:created_at, 2.days.from_now)

      get :index, request_params
      second_obj = assigns(:alerts)[1]

      get :index, { page: 2, limit: 1 }.merge(request_params)
      assigns(:alerts).should eq [second_obj]
    end

    it 'can filter by a type' do
      audio    = create :breaking_news_alert, :published, alert_type: "audio"
      breaking = create :breaking_news_alert, :published, alert_type: "break"

      get :index, { type: "audio" }.merge(request_params)
      assigns(:alerts).should eq [audio]
    end
  end
end
