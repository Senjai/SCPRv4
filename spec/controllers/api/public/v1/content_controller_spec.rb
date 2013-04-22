require "spec_helper"

describe Api::Public::V1::ContentController do
  request_params = {
    :format => :json
  }

  describe "GET show" do
    it "finds the object if it exists" do
      entry = create :blog_entry
      get :show, { obj_key: entry.obj_key }.merge(request_params)
      response.body.should eq entry.to_json
    end

    it "returns a 404 status if it does not exist" do
      get :show, { obj_key: "nope" }.merge(request_params)
      response.response_code.should eq 404
      response.body.should eq Hash[error: "Not Found"].to_json
    end
  end

  describe "GET by_url" do
    it "finds the object if the URI matches" do
      entry = create :blog_entry
      get :by_url, { url: entry.remote_link_path }.merge(request_params)
      response.body.should eq entry.to_json
    end

    it "validates the URI, returning a bad request if not valid" do
      get :by_url, { url: '###' }.merge(request_params)
      response.response_code.should eq 400
    end

    it "returns a 404 if no object is found" do
      get :by_url, { url: "nope.com" }.merge(request_params)
      response.response_code.should eq 404
      response.body.should eq Hash[error: "Not Found"].to_json
    end
  end

  describe "GET index" do
    sphinx_spec(num: 1)

    it "returns only the requested classes" do
      entries = @generated_content.select { |c| c.class == BlogEntry }
      
      ts_retry(2) do
        get :index, { types: "blogs" }.merge(request_params)
        assigns(:content).should eq entries
      end
    end

    it "can take a comma-separated list of types" do
      ts_retry(2) do
        get :index, { types: "blogs,segments" }.merge(request_params)
        assigns(:classes).should eq [BlogEntry, ShowSegment]
        assigns(:content).any? { |c| !%w{ShowSegment BlogEntry}.include?(c.class.name) }.should eq false
      end
    end

    it "is all types by default" do
      ts_retry(2) do
        get :index, request_params
        assigns(:content).size.should eq @generated_content.size
      end
    end

    it "sanitizes the limit" do
      ts_retry(2) do
        get :index, { limit: "Evil Code" }.merge(request_params)
        assigns(:limit).should eq 0
        assigns(:content).should eq []
      end
    end

    it "accepts a limit" do
      ts_retry(2) do
        get :index, { limit: 1 }.merge(request_params)
        assigns(:content).size.should eq 1
      end
    end

    it "sets the max limit to 40" do
      ts_retry(2) do
        get :index, { limit: 100 }.merge(request_params)
        assigns(:limit).should eq 40
      end
    end

    it "sanitizes the page" do
      ts_retry(2) do
        get :index, { page: "Evil Code" }.merge(request_params)
        assigns(:page).should eq 1
        assigns(:content).size.should eq @generated_content.size
      end
    end

    it "accepts a page" do
      ts_retry(2) do
        get :index, request_params
        fifth_obj = assigns(:content)[4]

        get :index, { page: 5, limit: 1 }.merge(request_params)
        assigns(:content).should eq [fifth_obj]
      end
    end

    it "accepts a query" do
      entry = create :blog_entry, headline: "Spongebob Squarepants!"
      index_sphinx

      ts_retry(2) do
        get :index, { query: "Spongebob+Squarepants" }.merge(request_params)
        assigns(:content).should eq [entry]
      end
    end

    it "responds with an array of json objects as defined in the model" do
      ts_retry(2) do
        get :index, request_params
        response.body.should eq @generated_content.to_json
        response.header['Content-Type'].should match /json/
      end
    end
  end
end
