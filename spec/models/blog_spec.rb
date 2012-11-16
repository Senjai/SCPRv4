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
      blog.authors.to_sql.should match /order by position/i
    end
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
  end
end
