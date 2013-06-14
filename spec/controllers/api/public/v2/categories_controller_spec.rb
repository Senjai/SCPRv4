require "spec_helper"

describe Api::Public::V2::CategoriesController do
  request_params = {
    :format => :json
  }

  render_views

  describe "GET show" do
    it "finds the object if it exists" do
      category = create :category_news
      get :show, { id: category.slug }.merge(request_params)
      assigns(:category).should eq category
      response.should render_template "show"
    end

    it "returns a 404 status if it does not exist" do
      get :show, { id: "nope" }.merge(request_params)
      response.response_code.should eq 404
      response.body.should eq Hash[error: "Not Found"].to_json
    end
  end

  describe "GET index" do
    it 'returns all of the categories' do
      categories = create_list :category_news, 2
      get :index, request_params
      assigns(:categories).should eq categories
    end
  end
end
