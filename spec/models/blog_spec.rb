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
    
    it "only returns published entries if the blog is local" do
      blog = create :blog
      create_list :blog_entry, 2, blog: blog, status: 0
      create_list :blog_entry, 1, blog: blog, status: 5
      blog.entries.count.should eq 1
    end
    
    it "returns the remote feed entries if the blog is remote" do
      blog = create :remote_blog
      blog.entries.first.class.should eq Feedzirra::Parser::RSSEntry # This is a little too specific for my tastes, I'd like to test functionality regardless of which RSS library we're using
    end
  end
  
  describe "all_entries" do
    it "returns all entries" do
      blog = create :blog
      create_list :blog_entry, 2, blog: blog, status: 0
      blog.all_entries.count.should eq 2
    end
  end
  
  describe "remote_entries" do
    it "returns the feed entries" do
      blog = create :remote_blog
      blog.remote_entries.count.should eq blog.feed.entries.count
    end
  end
  
  describe "feed" do # Probably should mock this stuff so it doesn't actually access the feed every time I run tests...
    describe "with valid url" do
      it "finds the feed" do
        blog = build :blog, feed_url: "http://www.oncentral.org/rss/latest/"
        blog.feed.feed_url.should_not be_blank
      end
      
      it "returns entries" do
        blog = build :blog, feed_url: "http://www.oncentral.org/rss/latest/"
        blog.feed.entries.should_not be_blank # This is a poor way to test this, because if the feed is actually blank this will be false. Need to mock it.
      end
    end
    
    describe "with invalid url" do
      it "returns false if the feed url is blank" do
        blog = build :blog, feed_url: ""
        blog.feed.should be_false
      end
    
      it "Returns false if the feed url is not a feed" do
        blog = build :blog, feed_url: "scpr.org"
        blog.feed.should be_false
      end
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