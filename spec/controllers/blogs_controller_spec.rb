
require "spec_helper"

describe BlogsController do
  
  # ------------------------
  
  describe "GET /index" do    
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
  
  # ------------------------
  
  describe "GET /show" do
    describe "for invalid blogs" do
      it "responds with RecordNotFound on invalid slug" do
        blog = create :blog
        -> { 
          get :show, blog: "nonsense"
        }.should raise_error ActiveRecord::RecordNotFound
      end
  
      it "responds with RecordNotFound for a remote blog" do
        blog = create :blog, is_remote: true
        -> { 
          get :show, blog: blog.slug 
        }.should raise_error ActiveRecord::RecordNotFound
      end
    end
      
    describe "for valid blogs" do
      describe "with XML" do
        it "renders xml template when requested" do
          blog = create :blog
          get :show, blog: blog.slug, format: :xml
          response.should render_template 'blogs/show'
          response.header['Content-Type'].should match /xml/
        end
      end
      
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
        entry_pending = create :blog_entry, :pending, blog: blog
        entry_published = create :blog_entry, :published, blog: blog
        get :show, blog: blog.slug
        assigns(:entries).should eq [entry_published]
      end
    
      it "paginates" do
        blog = create(:blog, entry_count: 10)
        get :show, blog: blog.slug, page: 1
        assigns(:entries).size.should be < 10
      end
    end
  end
  
  # ------------------------
  
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
      assigns(:recent).to_sql.should match /order by blogs_entry.published_at desc/i
    end
  end
  
  # ------------------------
  
  describe "GET /blog_tagged" do
    let(:blog) { create :blog }
    it "responds with success" do
      tag = create :tag
      get :blog_tagged, blog: blog.slug, tag: tag.slug
      response.should be_success
    end
    
    it "redirects if tag doesn't exist" do
      get :blog_tagged, blog: blog.slug, tag: "nonsense"
      response.should redirect_to blog_tags_path(blog.slug)
    end
    
    it "assigns @tag" do
      tag = create :tag
      get :blog_tagged, blog: blog.slug, tag: tag.slug
      assigns(:tag).should eq tag
    end
    
    it "assigns @entries" do
      blog_entry = create :blog_entry, tag_count: 1, blog: blog
      get :blog_tagged, blog: blog.slug, tag: blog_entry.tags.first.slug
      assigns(:entries).should eq blog_entry.tagged.all
      assigns(:entries).collect { |e| e.content }.should eq [blog_entry]
    end
  end
  
  # ------------------------
  
  describe "load_blog" do
    before :all do
      @blog = create :blog
      entry_published = create :blog_entry, blog: @blog
      p = entry_published.published_at
      @entry_attr = { blog: @blog.slug, 
                      tag: "news", 
                      id: entry_published.id, 
                      slug: entry_published.slug }.merge(date_path(p))
    end
    
    after :all do
      @blog = nil
    end
    
    %w{ show entry blog_tags blog_tagged }.each do |action|
      it "assigns @blog for #{action}" do
        get action, @entry_attr
        assigns(:blog).should eq @blog
      end

      it "assigns @authors for #{action}" do
        get action, @entry_attr
        assigns(:authors).should_not be_nil
      end
      
      it "raises RecordNotFound if blog isn't found" do
        -> { 
          get action, @entry_attr.merge(blog: "nonsense") 
        }.should raise_error ActiveRecord::RecordNotFound
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
  
  # ------------------------
  
  describe "GET /entry" do
    describe "for invalid entry" do
      it "raises a routing error for unpublished" do
        entry = create :blog_entry, :pending
        -> {
          get :entry, { blog: entry.blog.slug, 
                        id: entry.id, 
                        slug: entry.slug }.merge!(date_path(entry.published_at))
        }.should raise_error ActiveRecord::RecordNotFound
      end
      
      it "raises a routing error for invalid ID" do
        entry = create :blog_entry
        -> {
          get :entry, { blog: entry.blog.slug, 
                        id: "999999", 
                        slug: entry.slug }.merge!(date_path(entry.published_at))
        }.should raise_error ActiveRecord::RecordNotFound
      end
    end
    
    describe "for valid entry" do
      let(:entry) { create :blog_entry }
      
      before :each do
        get :entry, { blog: entry.blog.slug, 
                      id: entry.id, 
                      slug: entry.slug }.merge!(date_path(entry.published_at))
      end
      
      it "responds with success" do
        response.should be_success
      end
    
      it "assigns @entry" do
        assigns(:entry).should eq entry
      end
    end
  end

  # ------------------------

  describe "GET /category" do
    before :each do
      @blog = create :blog
      @category = create :blog_category, blog: @blog
    end
  
    it "raises 404 if category isn't found" do
      -> {
        get :category, blog: @blog.slug, category: "nonsense"
      }.should raise_error ActiveRecord::RecordNotFound
    end
  
    it "assigns category if it's found with the correct blog id" do
      get :category, blog: @blog.slug, category: @category.slug
      assigns(:category).should eq @category
    end
  
    it "only searches in the scope of the blog id and category together" do
      other_blog = create :blog
      -> {
        get :category, blog: other_blog.slug, category: @category.slug
      }.should raise_error ActiveRecord::RecordNotFound
    end
  
    it "assigns entries if category is found" do
      get :category, blog: @blog.slug, category: @category.slug
      assigns(:entries).should_not be_nil
    end
    
    it "only selects entries with that category" do
      entries = create_list :blog_entry, 3, blog: @blog
      other_category = create :blog_category, blog: @blog
      
      @category.blog_entries.push entries.first
      other_category.blog_entries.push entries.last(2)
              
      get :category, blog: @blog.slug, category: @category.slug
      assigns(:entries).should eq [entries.first]
    end
    
    it "only select published content" do
      pub_entries = create_list :blog_entry, 2, blog: @blog
      unpub_entries = create_list :blog_entry, 2, :draft, blog: @blog
                        
      @category.blog_entries.push (pub_entries + unpub_entries)
      get :category, blog: @blog.slug, category: @category.slug
      
      assigns(:entries).select { |e| 
        !e.published? 
      }.should be_blank
    end
    
    it "orders by published_at desc" do
      get :category, blog: @blog.slug, category: @category.slug
      assigns(:entries).to_sql.should match /order by published_at desc/i
    end
    
    it "paginates" do
      entries = create_list :blog_entry, 15
      @category.blog_entries.push entries
      
      get :category, blog: @blog.slug, category: @category.slug
      assigns(:entries).size.should be < 15
    end
  end
  
  # ------------------------
  
  describe "GET /process_archive_select" do
    let(:blog) { create :blog }
    it "redirects to blog_archive_path with the processed date" do
      get :process_archive_select, blog: blog.slug, 
        archive: { "date(1i)" => "2012", "date(2i)" => "4", "date(3i)" => "1" }
      response.should redirect_to blog_archive_path(blog.slug, "2012", "04")
    end
  end

  # ------------------------
  
  describe "GET /archive" do
    let(:blog) { create :blog }

    before :each do
      stub_publishing_callbacks(BlogEntry)
    end
    
    it "only select entries in the correct date range" do      
      entry_jan = create :blog_entry, blog: blog, published_at: Chronic.parse("January 10, 2012")
      entry_feb = create :blog_entry, blog: blog, published_at: Chronic.parse("February 10, 2012")
      get :archive, blog: blog.slug, year: "2012", month: "01"
      assigns(:entries).should eq [entry_jan]
    end
    
    it "only selects published entries" do
      date = Time.new("2012", "07")
      
      entry_pub = create :blog_entry, :published, blog: blog, 
                          published_at: date
      entry_unpub = create :blog_entry, :draft, blog: blog, 
                            published_at: date
      get :archive, { blog: blog.slug }.merge!(date_path(date))
      assigns(:entries).should eq [entry_pub]
    end
  end
  
  # ------------------------
  
  describe "GET /legacy_path" do
    it "redirects if blog entry is found" do
      entry = create :blog_entry
      date  = entry.published_at
      get :legacy_path, blog: entry.blog.slug, 
                        year: date.year.to_s, 
                        month: "%02d" % date.month, 
                        slug: entry.slug
      controller.should redirect_to entry.link_path
    end
    
    it "raises RecordNotFound if post not found" do
      entry = create :blog_entry
      -> {
        get :legacy_path, blog: entry.blog.slug, year: "2000", month: "01", slug: "nonsense"
      }.should raise_error ActiveRecord::RecordNotFound
    end
    
    it "only responds to published entries" do
      entry = create :blog_entry, :pending
      date  = entry.published_at
      -> {
        get :legacy_path, blog: entry.blog.slug, 
                          year: date.year.to_s, 
                          month: "%02d" % date.month, 
                          slug: entry.slug
      }.should raise_error ActiveRecord::RecordNotFound
    end
    
    it "truncates the slug if it's more than 50 characters" do
      slug  = "this-is-a-really-long-slug-that-we-will-have-to-truncate-otherwise-its-just-riduculous"
      entry = create :blog_entry, slug: slug[0,50]
      date  = entry.published_at
      get :legacy_path, blog: entry.blog.slug,
                        year: date.year.to_s, 
                        month: "%02d" % date.month, 
                        slug: slug
      controller.should redirect_to entry.link_path
    end
  end
end
