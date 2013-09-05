require "spec_helper"

describe Api::Public::V3::BucketsController do
  request_params = {
    :format => :json
  }

  render_views

  describe "GET show" do
    it "finds the object if it exists" do
      bucket = create :missed_it_bucket
      get :show, { id: bucket.slug }.merge(request_params)
      assigns(:bucket).should eq bucket
      response.should render_template "show"
    end

    it "does not include the articles array" do
      bucket = create :missed_it_bucket
      get :show, { id: bucket.slug }.merge(request_params)
      response.body.should match /articles/
    end

    it "returns a 404 status if it does not exist" do
      get :show, { id: "nope" }.merge(request_params)
      response.response_code.should eq 404
      response.body.should eq Hash[error: "Not Found"].to_json
    end
  end

  describe "GET index" do
    it 'returns all of le buckets' do
      buckets = create_list :missed_it_bucket, 2
      get :index, request_params
      assigns(:buckets).should eq buckets
    end

    it "does not include the articles array" do
      bucket = create :missed_it_bucket
      get :index, request_params
      response.body.should_not match /articles/
    end
  end
end
