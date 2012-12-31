require "spec_helper"

describe BlogsController do
  describe "GET /index" do
    describe "view" do
      render_views
      
      it "renders the view" do
        get :index
      end
    end
    
    #---------------------
    
    describe "controller" do
      it "renders the application layout" do
        get :index
        response.should render_template "layouts/application"
      end
       
      it "assigns @blogs" do
        blog = create :blog
        get :index
        assigns(:blogs).should eq [blog]
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
    end
  end
  
  # ------------------------
  
  describe "GET /show" do
    describe "view" do
      render_views
      
      it "renders the view" do
        blog = create :blog
        get :show, blog: blog.slug
      end
    end
    
    #------------------------
    
    describe "controller" do
      context "for invalid blogs" do
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
      
      context "for valid blogs" do
        describe "with XML" do
          it "renders xml template when requested" do
            blog = create :blog
            get :show, blog: blog.slug, format: :xml
            response.should render_template 'blogs/show'
            response.header['Content-Type'].should match /xml/
          end
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
      end
    end
  end
  
  # ------------------------
  
  describe "GET /blog_tags" do
    describe "view" do
      render_views
      
      it "renders the view" do
        blog = create :blog
        get :blog_tags, blog: blog.slug
      end
    end

    # ------------------------
    
    describe "controller" do
      let(:blog) { create :blog }

      it "assigns blog tags to @recent" do
        entry = build :blog_entry, blog: blog
        tags  = create_list :tag, 1
        entry.tags = tags
        entry.save!
        
        get :blog_tags, blog: blog.slug
        assigns(:recent).should eq tags
      end
    end
  end
  
  # ------------------------
  
  describe "GET /blog_tagged" do
    describe "view" do
      render_views
      
      it "renders the view" do
        blog = create :blog
        tag  = create :tag
        get :blog_tagged, blog: blog.slug, tag: tag.slug
      end
    end
    
    # ------------------------

    describe "controller" do
      let(:blog) { create :blog }
      let(:tag) { create :tag }
      
      it "redirects if tag doesn't exist" do
        get :blog_tagged, blog: blog.slug, tag: "nonsense"
        response.should redirect_to blog_tags_path(blog.slug)
      end
    
      it "assigns @tag" do
        get :blog_tagged, blog: blog.slug, tag: tag.slug
        assigns(:tag).should eq tag
      end
    
      it "assigns @entries" do
        entry = build :blog_entry, blog: blog
        entry.tags = [tag]
        entry.save!
        
        get :blog_tagged, blog: blog.slug, tag: tag.slug
        assigns(:entries).should eq [entry]
      end
    end
  end
  
  # ------------------------
  
  describe "load_blog" do
    before :each do
      @blog = create :blog
      entry_published = create :blog_entry, blog: @blog
      p = entry_published.published_at
      @entry_attr = { blog: @blog.slug, 
                      tag: "news", 
                      id: entry_published.id, 
                      slug: entry_published.slug }.merge(date_path(p))
    end
    
    %w{ show entry blog_tags blog_tagged }.each do |action|
      it "assigns @blog for #{action}" do
        get action, @entry_attr
        assigns(:blog).should eq @blog
      end
    end
    
    it "raises RecordNotFound if blog isn't found" do
      -> { 
        get :show, @entry_attr.merge(blog: "nonsense") 
      }.should raise_error ActiveRecord::RecordNotFound
    end
  end
  
  # ------------------------
  
  describe "GET /entry" do
    describe "view" do
      render_views
      
      it "renders the view" do
        entry = create :blog_entry
        get :entry, { blog: entry.blog.slug, 
                      id: entry.id, 
                      slug: entry.slug }.merge!(date_path(entry.published_at))
      end
    end
    
    describe "controller" do
      context "for invalid entry" do
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
    
      context "for valid entry" do
        let(:entry) { create :blog_entry }
      
        before :each do
          get :entry, { blog: entry.blog.slug, 
                        id: entry.id, 
                        slug: entry.slug }.merge!(date_path(entry.published_at))
        end

        it "assigns @entry" do
          assigns(:entry).should eq entry
        end
      end
    end
  end

  # ------------------------

  describe "GET /category" do
    describe "view" do
      render_views
      
      it "renders the view" do
        blog = create :blog
        category = create :blog_category, blog: blog
        get :category, blog: blog.slug, category: category.slug
      end
    end
    
    describe "controller" do
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
    describe "view" do
      render_views
      
      it "renders the view" do
        blog = create :blog
        get :archive, blog: blog.slug, year: "2012", month: "01"
      end
    end
    
    describe "controller" do
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
