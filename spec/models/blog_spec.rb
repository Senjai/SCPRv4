require "spec_helper"

describe Blog do
  describe "validations" do
    it_behaves_like "slug validation"
    it_behaves_like "slug unique validation"
    it { should validate_presence_of(:name) }
  end
  
  #----------------
  
  describe "associations" do
    it { should have_many :entries }
    it { should have_many(:tags).through(:entries) }
    it { should belong_to(:missed_it_bucket) }
    it { should have_many(:authors).through(:blog_authors) }
    it { should have_many(:blog_categories) }
    
    it "orders by position on authors" do
      blog = create :blog
      create_list :blog_author, 3, blog: blog
      blog.authors.to_sql.should match /order by position/i
    end
  end

  #----------------
  
  describe "entries" do
    it "returns the local entries if the blog is local" do
      blog = create :blog
      create_list :blog_entry, 2, blog: blog
      blog.entries.first.class.should eq BlogEntry
    end
    
    it "returns all entries if the blog is local" do
      blog = create :blog
      create_list :blog_entry, 2, blog: blog, status: 0
      create_list :blog_entry, 1, blog: blog, status: 5
      blog.entries.count.should eq 3
    end
  end

  #----------------
  
  describe "cache_remote_entries" do
    it "does not cache local blogs" do
      Feedzirra::Feed.stub!(:fetch_and_parse) { Feedzirra::Feed.parse(load_fixture("rss.xml")) }
      blog = create :blog
      Blog.cache_remote_entries.should be_blank
    end
    
    it "returns the blogs it cached" do
      Feedzirra::Feed.stub!(:fetch_and_parse) { Feedzirra::Feed.parse(load_fixture("rss.xml")) }
      blogs = create_list :blog, 2, :remote
      Blog.cache_remote_entries.count.should eq 2
    end
    
    it "creates a cache for each remote blog" do
      Feedzirra::Feed.stub!(:fetch_and_parse) { Feedzirra::Feed.parse(load_fixture("rss.xml")) }
      blogs = create_list :blog, 2, :remote
      Blog.cache_remote_entries
      blogs.each { |blog| Rails.cache.fetch("remote_blog:#{blog.slug}").should_not be_blank }
    end
    
    it "Does not cache if the feed_url isn't found" do
      Feedzirra::Feed.stub!(:fetch_and_parse) { 0 }
      blog = create :blog, :remote, feed_url: "Invalid URL"
      Blog.cache_remote_entries.should be_blank
    end
    
    it "responds with all the successful caches" do
      pending "Need to solve the stubbing here"
      Feedzirra::Feed.stub!(:fetch_and_parse) { Feedzirra::Feed.parse(load_fixture("rss.xml")) }
      create :blog, :remote
      create :blog, :remote, feed_url: "Invalid"
      Blog.cache_remote_entries.count.should eq 1
    end
  end
  
  #----------------
  
  describe "scopes" do
    describe "#active" do
      it "returns only active blogs" do
        active_blogs   = create_list :blog, 1, is_active: true
        inactive_blogs = create_list :blog, 2, is_active: false
        Blog.active.should eq active_blogs
      end
    end
    
    describe "#is_news" do
      it "returns only news blogs" do
        news_blogs     = create_list :blog, 1, is_news: true
        non_news_blogs = create_list :blog, 2, is_news: false
        Blog.is_news.should eq news_blogs
      end
    end
    
    describe "#is_not_news" do
      it "returns only non-news blogs" do
        news_blogs     = create_list :blog, 1, is_news: true
        non_news_blogs = create_list :blog, 2, is_news: false
        Blog.is_not_news.should eq non_news_blogs
      end
    end
    
    describe "#local" do
      it "returns only local blogs" do
        local_blogs  = create_list :blog, 1, is_remote: false
        remote_blogs = create_list :blog, 2, is_remote: true
        Blog.local.should eq local_blogs
      end
    end
    
    describe "#remote" do
      it "returns only remote blogs" do
        local_blogs  = create_list :blog, 1, is_remote: false
        remote_blogs = create_list :blog, 2, is_remote: true
        Blog.remote.should eq remote_blogs
      end
    end
  end
end
