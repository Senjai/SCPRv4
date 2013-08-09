require "spec_helper"

describe Api::Public::V3::BlogsController do
  request_params = {
    :format => :json
  }

  render_views

  describe "GET show" do
    it "finds the object if it exists" do
      blog = create :blog, slug: 'hello'
      get :show, { id: blog.slug }.merge(request_params)
      assigns(:blog).should eq blog
      response.should render_template "show"
    end

    it "returns a 404 status if it does not exist" do
      get :show, { id: "nonono" }.merge(request_params)
      response.response_code.should eq 404
      response.body.should eq Hash[error: "Not Found"].to_json
    end
  end

  describe "GET index" do
    it "returns all blogs" do
      blog = create :blog
      get :index, request_params
      assigns(:blogs).should eq [blog]
    end
  end
end
