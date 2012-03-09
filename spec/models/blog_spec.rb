require "spec_helper"

describe Blog do
  describe "teaser" do
    it "Returns _teaser" do
      blog = build :blog
      blog.teaser.should eq blog._teaser
    end
  end
  
  describe "to_param" do
    it "return the slug" do
      blog = build :blog
      blog.to_param.should eq blog.slug
    end
  end
  
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
  
  describe "cache_remote_entries" do
    it "does not cache local blogs" do
      blog = create :blog
      Blog.cache_remote_entries.should be_blank
    end
    
    it "returns the blogs it cached" do
      blogs = create_list :remote_blog, 2
      Blog.cache_remote_entries.count.should eq 2
    end
    
    it "creates a cache for each remote blog" do
      blogs = create_list :remote_blog, 2
      Blog.cache_remote_entries
      blogs.each { |blog| Rails.cache.fetch("remote_blog:#{blog.slug}").should_not be_blank }
    end
    
    it "Does not cache if the feed_url isn't found" do
      blog = create :remote_blog, feed_url: "Invalid URL"
      Blog.cache_remote_entries.should be_blank
    end
    
    it "responds with all the successful caches" do
      create :remote_blog
      create :remote_blog, feed_url: "Invalid"
      Blog.cache_remote_entries.count.should eq 1 
    end
  end
  
  describe "scopes" do
    describe "#active" do
      it "returns only active blogs" do
        active_blogs = create_list :blog, 1, is_active: true
        inactive_blogs = create_list :blog, 2, is_active: false
        Blog.active.count.should eq 1
        Blog.active.first.should eq active_blogs.first # sort of passively testing order too, probably not good
      end
    end
    
    describe "#is_news" do
      it "returns only news blogs" do
        news_blogs = create_list :blog, 1, is_news: true
        non_news_blogs = create_list :blog, 2, is_news: false
        Blog.is_news.count.should eq 1
        Blog.is_news.first.should eq news_blogs.first
      end
    end
    
    describe "#is_not_news" do
      it "returns only non-news blogs" do
        news_blogs = create_list :blog, 1, is_news: true
        non_news_blogs = create_list :blog, 2, is_news: false
        Blog.is_not_news.count.should eq 2
        Blog.is_not_news.first.should eq non_news_blogs.first
      end
    end
    
    describe "#local" do
      it "returns only local blogs" do
        local_blogs = create_list :blog, 1, is_remote: false
        remote_blogs = create_list :blog, 2, is_remote: true
        Blog.local.count.should eq 1
        Blog.local.first.should eq local_blogs.first
      end
    end
    
    describe "#remote" do
      it "returns only remote blogs" do
        local_blogs = create_list :blog, 1, is_remote: false
        remote_blogs = create_list :blog, 2, is_remote: true
        Blog.remote.count.should eq 2
        Blog.remote.first.should eq remote_blogs.first
      end
    end
  end
end