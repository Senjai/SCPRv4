require "spec_helper"

describe BlogsController do
  describe "GET /index" do
    it "responds with success" do
      get :index
      response.should be_success
    end
    
    it "renders the application layout" do
      get :index
      response.should render_template "layouts/application"
    end
       
    it "assigns @blogs" do
      blog = create :blog
      get :index
      assigns(:blogs).should eq [blog]
    end
    
    it "doesn't assign @blog" do
      get :index
      assigns(:blog).should be_nil
    end
    
    it "orders @blogs by name" do
      get :index
      assigns(:blogs).to_sql.should match /order by name/i
    end
    
    it "only assigns active blogs to @blogs" do
      create :blog, is_active: false
      active_blog = create :blog, is_active: true
      get :index
      assigns(:blogs).should eq [active_blog]
    end
    
    it "assigns @news_blogs" do
      blog = create :blog, is_remote: false, is_news: true
      get :index
      assigns(:news_blogs).should eq [blog]
    end
    
    it "assigns @non_news_blogs" do
      blog = create :blog, is_remote: false, is_news: false
      get :index
      assigns(:non_news_blogs).should eq [blog]
    end
    
    it "assigns @remote_blogs" do
      blog = create :blog, is_remote: true
      get :index
      assigns(:remote_blogs).should eq [blog]
    end
    
    it "orders @remote_blogs by name" do
      create :blog, is_remote: true
      get :index
      assigns(:remote_blogs).to_sql.should match /order by name/i
    end
  end
  
  describe "GET /show" do
    it "responds with success" do
      blog = create :blog
      get :show, blog: blog.slug
      response.should be_success
    end
    
    it "assigns @blog" do
      blog = create :blog, is_remote: false
      get :show, blog: blog.slug
      assigns(:blog).should eq blog
    end
    
    it "assigns @entries" do
      blog = create :blog
      get :show, blog: blog.slug
      assigns(:entries).should_not be_nil
    end
    
    it "only gets published entries" do
      blog = create :blog
      entry_pending = create :blog_entry, blog: blog, status: ContentBase::STATUS_PENDING
      entry_published = create :blog_entry, blog: blog, status: ContentBase::STATUS_LIVE
      get :show, blog: blog.slug
      assigns(:entries).should eq [entry_published]
    end
    
    it "paginates" do
      blog = create(:blog, entry_count: 10)
      get :show, blog: blog.slug, page: 1
      assigns(:entries).size.should be < 10
    end
  end
  
  describe "GET /blog_tags" do
    it "responds with success" do
      blog = create :blog
      get :blog_tags, blog: blog.slug
      response.should be_success
    end
    
    it "assigns @blog" do
      blog = create :blog, is_remote: false
      get :show, blog: blog.slug
      assigns(:blog).should eq blog
    end
    
    it "assigns @recent" do
      blog = create :blog
      get :blog_tags, blog: blog.slug
      assigns(:recent).should_not be_nil
    end
    
    it "assigns blog tags to @recent" do
      pending "Need Tag factory"
    end
    
    it "orders tags by blog entry published desc" do
      blog = create :blog
      get :blog_tags, blog: blog.slug
      assigns(:recent).to_sql.should match /blogs_entry.published_at desc/i
    end
  end
  
  describe "GET /blog_tagged" do
    it "responds with success" do
      pending "Need Tag factory"
      blog = create :blog
      get :blog_tagged, blog: blog.slug, tag: "news"
      response.should be_success
    end
    
    it "redirects if tag doesn't exist" do
      blog = create :blog
      get :blog_tagged, blog: blog.slug, tag: "nonsense"
      response.should redirect_to blog_tags_path(blog.slug)
    end
    
    it "assigns @tag" do
      pending "Need Tag factory"
      blog = create :blog
      get :blog_tagged, blog: blog.slug, tag: "news"
      assigns(:tag).should_not be_nil
    end
  end
  
  describe "load_blog" do
    before :all do
      @blog = create :blog
      entry_published = create :blog_entry, blog: @blog
      p = entry_published.published_at
      @entry_attr = { id: entry_published.id, year: p.year, month: p.month, day: p.day }
    end
    
    after :all do
      @date, @blog = nil
    end
    
    %w{ show entry blog_tags blog_tagged }.each do |action|
      it "assigns @blog for #{action}" do
        get action, { blog: @blog.slug, tag: "news" }.merge!(@entry_attr)
        assigns(:blog).should eq @blog
      end

      it "assigns @authors for #{action}" do
        get action, { blog: @blog.slug, tag: "news" }.merge!(@entry_attr)
        assigns(:authors).should_not be_nil
      end
      
      it "redirects to blogs_path if blog isn't found" do
        get action, blog: "nonsense"
        response.should redirect_to blogs_path
      end
    end
    
    %w{ index }.each do |action|
      it "does not assign @blog for #{action}" do
        get action, blog: @blog.slug
        assigns(:blog).should be_nil
      end

      it "does not assign @authors for #{action}" do
        get action, blog: @blog.slug
        assigns(:authors).should be_nil
      end      
    end
  end
  
  describe "GET /entry" do
    it "responds with success" do
      blog = create :blog
      entry_published = create :blog_entry, blog: blog, status: ContentBase::STATUS_LIVE
      p = entry_published.published_at
      get :entry, blog: blog.slug, year: p.year, month: p.month, day: p.day, id: entry_published.id, slug: entry_published.slug
      response.should be_success
    end
    
    it "assigns @blog" do
      blog = create :blog, is_remote: false
      get :show, blog: blog.slug
      assigns(:blog).should eq blog
    end
    
    it "assigns @entry" do
      blog = create :blog
      entry_published = create :blog_entry, blog: blog, status: ContentBase::STATUS_LIVE
      p = entry_published.published_at
      get :entry, blog: blog.slug, year: p.year, month: "%02d" % p.month, day: "%02d" % p.day, id: entry_published.id, slug: entry_published.slug
      assigns(:entry).should eq entry_published
    end
    
    it "raises a routing error if entry isn't found" do
      blog = create :blog
      entry_unpublished = create :blog_entry, blog: blog, status: ContentBase::STATUS_PENDING
      p = entry_unpublished.published_at
      -> {
        get :entry, blog: blog.slug, year: p.year, month: "%02d" % p.month, day: "%02d" % p.day, id: entry_unpublished.id, slug: entry_unpublished.slug
      }.should raise_error ActionController::RoutingError
    end
  end
end