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
        blog = create :blog, is_news: true
        get :index
        assigns(:news_blogs).should eq [blog]
      end
    
      it "assigns @non_news_blogs" do
        blog = create :blog, is_news: false
        get :index
        assigns(:non_news_blogs).should eq [blog]
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
  
  describe "load_blog" do
    before :each do
      @blog = create :blog
      entry_published = create :blog_entry, blog: @blog
      p = entry_published.published_at
      @entry_attr = { blog: @blog.slug, 
                      id: entry_published.id, 
                      slug: entry_published.slug }.merge(date_path(p))
    end
    
    %w{ show entry }.each do |action|
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
        entry_jan = create :blog_entry, blog: blog, published_at: Time.new(2012, 1, 10)
        entry_feb = create :blog_entry, blog: blog, published_at: Time.new(2012, 2, 10)
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
end
