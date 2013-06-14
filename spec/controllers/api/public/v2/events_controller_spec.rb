require "spec_helper"

describe Api::Public::V2::EventsController do
  request_params = {
    :format => :json
  }

  render_views

  describe "GET show" do
    it "finds the object if it exists" do
      entry = create :blog_entry
      get :show, { obj_key: entry.obj_key }.merge(request_params)
      assigns(:event).should eq entry.to_event
      response.should render_template "show"
    end

    it "returns a 404 status if it does not exist" do
      get :show, { obj_key: "nope" }.merge(request_params)
      response.response_code.should eq 404
      response.body.should eq Hash[error: "Not Found"].to_json
    end
  end

  describe "GET index" do
    sphinx_spec(num: 1)

    it 'can filter by category' do
      category1  = create :category_not_news, slug: "film"
      story1     = create :news_story, category: category1, published_at: 1.hour.ago

      category2  = create :category_news, slug: "health"
      story2     = create :news_story, category: category2, published_at: 2.hours.ago

      # Control - add these in to make sure we're *only* returning
      # stories with the requested categories
      other_stories = create_list :news_story, 2

      index_sphinx

      ts_retry(2) do
        get :index, { categories: "film,health" }.merge(request_params)
        assigns(:events).should eq [story1, story2].map(&:to_event)
      end
    end

    it "returns only the requested classes" do
      entries = @generated_content.select { |c| c.class == BlogEntry }
      
      ts_retry(2) do
        get :index, { types: "blogs" }.merge(request_params)
        assigns(:events).should eq entries.map(&:to_event)
      end
    end

    it "can take a comma-separated list of types" do
      ts_retry(2) do
        get :index, { types: "blogs,segments" }.merge(request_params)
        assigns(:classes).should eq [BlogEntry, ShowSegment]
        assigns(:events).any? { |c| !%w{ShowSegment BlogEntry}.include?(c.original_object.class.name) }.should eq false
      end
    end

    it "is all types by default" do
      ts_retry(2) do
        get :index, request_params
        assigns(:events).size.should eq @generated_content.size
      end
    end

    it "sanitizes the limit" do
      ts_retry(2) do
        get :index, { limit: "Evil Code" }.merge(request_params)
        assigns(:limit).should eq 0
        assigns(:events).should eq []
      end
    end

    it "accepts a limit" do
      ts_retry(2) do
        get :index, { limit: 1 }.merge(request_params)
        assigns(:events).size.should eq 1
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
        assigns(:events).size.should eq @generated_content.size
      end
    end

    it "accepts a page" do
      ts_retry(2) do
        get :index, request_params
        fifth_obj = assigns(:events)[4]

        get :index, { page: 5, limit: 1 }.merge(request_params)
        assigns(:events).should eq [fifth_obj].map(&:to_event)
      end
    end

    it "accepts a query" do
      entry = create :blog_entry, headline: "Spongebob Squarepants!"
      index_sphinx

      ts_retry(2) do
        get :index, { query: "Spongebob+Squarepants" }.merge(request_params)
        assigns(:events).should eq [entry].map(&:to_event)
      end
    end
  end
end
