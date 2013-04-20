require "spec_helper"

describe Api::Private::V1::ContentController do
  describe "GET index" do
    sphinx_spec(num: 1)

    it "returns only the requested classes" do
      entries = @generated_content.select { |c| c.class == BlogEntry }
      
      get :index, types: "blogs", token: Rails.application.config.api['assethost']['token']
      assigns(:content).should eq entries
    end

    it "can take a comma-separated list of types" do
      get :index, types: "blogs,segments", token: Rails.application.config.api['assethost']['token']
      assigns(:content).any? { |c| !%w{ShowSegment BlogEntry}.include?(c.class.name) }.should eq false
    end

    it "is all types by default" do
      get :index, token: Rails.application.config.api['assethost']['token']
      assigns(:content).size.should eq @generated_content.size
    end

    it "sanitizes the limit" do
      get :index, limit: "Evil Code", token: Rails.application.config.api['assethost']['token']
      assigns(:content).should eq []
    end

    it "accepts a limit" do
      get :index, limit: 1, token: Rails.application.config.api['assethost']['token']
      assigns(:content).size.should eq 1
    end

    it "sanitizes the page" do
      get :index, page: "Evil Code", token: Rails.application.config.api['assethost']['token']
      assigns(:content).size.should eq @generated_content.size
    end

    it "accepts a page" do
      get :index, token: Rails.application.config.api['assethost']['token']
      fifth_obj = assigns(:content)[4]

      get :index, page: 5, limit: 1, token: Rails.application.config.api['assethost']['token']
      assigns(:content).should eq [fifth_obj]
    end

    it "accepts a query" do
      entry = create :blog_entry, headline: "Spongebob Squarepants!"
      index_sphinx

      get :index, query: "Spongebob+Squarepants", token: Rails.application.config.api['assethost']['token']
      assigns(:content).should eq [entry]
    end

    it "uses the passed-in sort mode if it's kosher" do
      entry = create :blog_entry, published_at: 2.years.ago
      index_sphinx

      get :index, order: "published_at", sort_mode: "asc", token: Rails.application.config.api['assethost']['token']
      assigns(:content).first.should eq entry
    end

    it "uses desc if the passed-in sort mode is not kosher" do
      entry = create :blog_entry, published_at: 2.years.from_now
      index_sphinx

      get :index, order: "published_at", sort_mode: "Evil Sort Mode", token: Rails.application.config.api['assethost']['token']
      assigns(:content).first.should eq entry
    end

    it "can accept conditions" do
      entry = create :blog_entry, status: ContentBase::STATUS_DRAFT
      index_sphinx

      get :index, conditions: { status: ContentBase::STATUS_DRAFT }, token: Rails.application.config.api['assethost']['token']
      assigns(:content).should eq [entry]
    end
  end
end
