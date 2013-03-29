require "spec_helper"

describe RootPathController do
  describe "category" do
    render_views

    it "assigns @category" do
      category = create :category_news
      
      get :handle_path, path: category.slug
      assigns(:category).should eq category
    end
    
    describe "with XML" do
      it "renders xml template when requested" do
        category = create :category_news
        
        get :handle_path, path: category.slug, format: :xml
        response.should render_template 'category/show'
        response.header['Content-Type'].should match /xml/
      end
    end
  end

  #------------------

  describe "section" do
    render_views
  
    describe "GET /show" do
      context "valid section" do
        let(:section) { create :section, slug: "politics" }
        
        context "html request" do
          before :each do
            get :handle_path, path: section.slug
          end
        
          it "sets @section to the correct section" do
            assigns(:section).should eq section
          end
      
          it "sets content do the section's content" do
            assigns(:content).should eq section.content
          end
        end
        
        context "xml request" do
          it "returns an XML response" do
            get :handle_path, path: section.slug, format: :xml
            response.should render_template "sections/show"
            response.header['Content-Type'].should match /xml/
          end
        end
      end
    end
  end

  #------------------

  describe "flatpage" do
    context "rendering" do
      render_views  
      
      it "assigns @flatpage" do
        flatpage = create :flatpage
        get :handle_path, path: flatpage.path
        assigns(:flatpage).should eq flatpage
      end
    
      it "redirects if redirect_url is present" do
        flatpage = create :flatpage, redirect_url: "http://google.com"
        get :handle_path, path: flatpage.path
        response.should be_redirect
      end
    end
    
    #------------------
    
    context "not rendering" do
      it "does not render a template if template is none" do
        flatpage = create :flatpage, template: "none"
        get :handle_path, path: flatpage.path
        response.should render_template(layout: false)
      end
      
      it "renders application layout by default" do
        flatpage = create :flatpage
        get :handle_path, path: flatpage.path
        response.should render_template(layout: "layouts/application")
      end
    
      it "render no_sidebar if template is full" do
        flatpage = create :flatpage, template: "full"
        get :handle_path, path: flatpage.path
        response.should render_template(layout: "layouts/app_nosidebar")
      end
    end
  end

  #------------------

  describe "404" do
  end
end
