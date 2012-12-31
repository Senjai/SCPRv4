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
  end

  #----------------
  
  describe "scopes" do
    describe "::active" do
      it "returns only active blogs" do
        active_blogs   = create_list :blog, 1, is_active: true
        inactive_blogs = create_list :blog, 2, is_active: false
        Blog.active.should eq active_blogs
      end
    end
  end

  #----------------
  
  describe "::cache_remote_entries" do
    it "does not cache local blogs" do
      blog = create :blog, is_remote: false
      Blog.cache_remote_entries.should be_blank
    end
    
    it "creates a cache for the remote blog" do
      Feedzirra::Feed.stub!(:fetch_and_parse) { Feedzirra::Feed.parse(load_fixture("rss.xml")) }
      blog = create :blog, :remote, feed_url: "http://feed.com/cool_feed"
      Rails.cache.fetch("remote_blog:#{blog.slug}").should eq nil
      Blog.cache_remote_entries
      Rails.cache.fetch("remote_blog:#{blog.slug}").should_not be_blank
    end
    
    it "Does not cache if the feed_url isn't found" do
      Feedzirra::Feed.stub!(:fetch_and_parse) { 500 }
      blog = create :blog, :remote, feed_url: "Invalid URL"
      Rails.cache.fetch("remote_blog:#{blog.slug}").should eq nil
      Blog.cache_remote_entries
      Rails.cache.fetch("remote_blog:#{blog.slug}").should eq nil
    end
  end
end
