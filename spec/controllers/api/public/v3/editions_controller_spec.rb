require "spec_helper"

describe Api::Public::V3::EditionsController do
  request_params = {
    :format => :json
  }

  render_views

  describe "GET show" do
    it "finds the object if it exists" do
      edition = create :edition, :published
      get :show, { id: edition.id }.merge(request_params)
      assigns(:edition).should eq edition
      response.should render_template "show"
    end

    it 'only returns published editions' do
      unpublished = create :edition, :unpublished
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
    it 'only returns published editions' do
      published   = create :edition, :published
      unpublished = create :edition, :unpublished

      get :index, request_params
      assigns(:editions).should eq [published]
    end

    it "sanitizes the limit" do
      editions = create_list :edition, 1, :published
      get :index, { limit: "Evil Code" }.merge(request_params)
      assigns(:limit).should eq 0
      assigns(:editions).should eq editions
    end

    it "accepts a limit" do
      create_list :edition, 2, :published
      get :index, { limit: 1 }.merge(request_params)
      assigns(:editions).size.should eq 1
    end

    it "sets the max limit to 4" do
      get :index, { limit: 100 }.merge(request_params)
      assigns(:limit).should eq 4
    end

    it "sanitizes the page" do
      get :index, { page: "Evil Code" }.merge(request_params)
      assigns(:page).should eq 1
    end

    it "accepts a page" do
      create_list :edition, 3, :published

      get :index, request_params
      second_obj = assigns(:editions)[1]

      get :index, { page: 2, limit: 1 }.merge(request_params)
      assigns(:editions).should eq [second_obj]
    end
  end
end
