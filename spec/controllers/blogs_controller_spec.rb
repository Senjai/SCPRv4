require "spec_helper"

describe BlogsController do
  describe "GET /index" do
    
    it "assigns @blogs" do
      blog = create :blog
      get :index
      blogs = assigns(:blogs)
      blogs.count.should eq 1
      blogs.last.should eq blog
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
      blogs = assigns(:blogs)
      blogs.count.should eq 1
      blogs.last.should eq active_blog
    end
    
    it "assigns @news_blogs" do
      blog = create :blog, is_remote: false, is_news: true
      get :index
      blogs = assigns(:news_blogs)
      blogs.count.should eq 1
      blogs.last.should eq blog
    end
    
    it "assigns @non_news_blogs" do
      blog = create :blog, is_remote: false, is_news: false
      get :index
      blogs = assigns(:non_news_blogs)
      blogs.count.should eq 1
      blogs.last.should eq blog
    end
    
    it "assigns @remote_blogs" do
      blog = create :blog, is_remote: true
      get :index
      blogs = assigns(:remote_blogs)
      blogs.count.should eq 1
      blogs.last.should eq blog
    end
    
    it "orders @remote_blogs by name" do
      create :blog, is_remote: true
      get :index
      assigns(:remote_blogs).to_sql.should match /order by name/i
    end
  end
  
  describe "GET /show" do
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
      entries = assigns(:entries)
      entries.should_not include entry_pending
    end
    
    it "paginates" do
      blog = create(:blog, entry_count: 10)
      get :show, blog: blog.slug, page: 1
      assigns(:entries).size.should be < 10
    end
  end
  
  describe "GET /blog_tags" do
    pending
  end
  
  describe "GET /blog_tagged" do
    pending
  end
  
  describe "#load_blog" do
    pending
  end
  
  
  describe "GET /entry" do
    it "assigns @entry" do
      blog = create :blog
      entry_published = create :blog_entry, blog: blog, status: ContentBase::STATUS_LIVE
      p = entry_published.published_at
      get :entry, blog: blog.slug, year: p.year, month: p.month, day: p.day, id: entry_published.id, slug: entry_published.slug
      assigns(:entry).should eq entry_published
    end
    
    it "raises a routing error if entry isn't found" do
      blog = create :blog
      entry_unpublished = create :blog_entry, blog: blog, status: ContentBase::STATUS_PENDING
      p = entry_unpublished.published_at
      lambda {
        get :entry, blog: blog.slug, year: p.year, month: p.month, day: p.day, id: entry_unpublished.id, slug: entry_unpublished.slug
      }.should raise_error ActionController::RoutingError
    end
  end
end