require "spec_helper"

describe Api::Private::V2::ArticlesController do
  request_params = {
    :token  => Rails.application.config.api['kpcc']['private']['api_token'],
    :format => :json
  }

  describe "authentication" do
    it "accepts a token" do
      get :index, request_params
      response.should be_success
    end

    it "denies the request if the token is wrong" do
      get :index, format: :json, token: "wrong"
      response.response_code.should eq 401
      response.body.should eq Hash[error: "Unauthorized"].to_json
    end
  end

  describe "GET show" do
    it "finds the object if it exists" do
      entry = create :blog_entry
      get :show, { obj_key: entry.obj_key }.merge(request_params)
      assigns(:article).should eq entry.to_article
      response.should render_template "show"
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
      get :by_url, { url: entry.public_url }.merge(request_params)
      assigns(:article).should eq entry.to_article
      response.should render_template "show"
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
        assigns(:articles).should eq entries.map(&:to_article)
      end
    end

    it "can take a comma-separated list of types" do
      ts_retry(2) do
        get :index, { types: "blogs,segments" }.merge(request_params)
        assigns(:classes).should eq [BlogEntry, ShowSegment]
        assigns(:articles).any? { |c| !%w{ShowSegment BlogEntry}.include?(c.original_object.class.name) }.should eq false
      end
    end

    it "is blogs,news,segments by default" do
      ts_retry(2) do
        get :index, request_params
        assigns(:articles).size.should eq @generated_content.select { |c|
          [BlogEntry, NewsStory, ShowSegment].include? c.class
        }.size
      end
    end

    it "sanitizes the limit" do
      ts_retry(2) do
        get :index, { limit: "Evil Code" }.merge(request_params)
        assigns(:limit).should eq 0
        assigns(:articles).should eq []
      end
    end

    it "accepts a limit" do
      ts_retry(2) do
        get :index, { limit: 1 }.merge(request_params)
        assigns(:articles).size.should eq 1
      end
    end

    it "sanitizes the page" do
      ts_retry(2) do
        get :index, { page: "Evil Code" }.merge(request_params)
        assigns(:page).should eq 1
      end
    end

    it "accepts a page" do
      ts_retry(2) do
        get :index, request_params
        third_obj = assigns(:articles)[2]

        get :index, { page: 3, limit: 1, types: "news,blogs,segments,shells" }.merge(request_params)
        assigns(:articles).should eq [third_obj].map(&:to_article)
      end
    end

    it "accepts a query" do
      entry = create :blog_entry, headline: "Spongebob Squarepants!"
      index_sphinx

      ts_retry(2) do
        get :index, { query: "Spongebob+Squarepants" }.merge(request_params)
        assigns(:articles).should eq [entry].map(&:to_article)
      end
    end

    it "uses the passed-in sort mode if it's kosher" do
      entry = create :blog_entry, published_at: 2.years.ago
      index_sphinx

      ts_retry(2) do
        get :index, { order: "published_at", sort_mode: "asc" }.merge(request_params)
        assigns(:sort_mode).should eq :asc
        assigns(:articles).first.should eq entry.to_article
      end
    end

    it "uses desc if the passed-in sort mode is not kosher" do
      entry = create :blog_entry, published_at: 2.years.from_now
      index_sphinx

      ts_retry(2) do
        get :index, { order: "published_at", sort_mode: "Evil Sort Mode" }.merge(request_params)
        assigns(:sort_mode).should eq :desc
        assigns(:articles).first.should eq entry.to_article
      end
    end

    it "can accept conditions" do
      entry = create :blog_entry, :draft
      index_sphinx

      ts_retry(2) do
        get :index, { with: { status: ContentBase::STATUS_DRAFT, is_live: ["1", "0"] } }.merge(request_params)
        assigns(:articles).should eq [entry].map(&:to_article)
      end
    end

    it "responds with an array of json objects as defined in the template" do
      ts_retry(2) do
        get :index, request_params
        response.should render_template "index"
        response.header['Content-Type'].should match /json/
      end
    end
  end
end
