require "spec_helper"

describe FlatpagesController do  
  describe "GET show" do    
    it "assigns @flatpage" do
      flatpage = create :flatpage
      get :show, flatpage_path: flatpage.path
      assigns(:flatpage).should eq flatpage
    end
    
    it "redirects if redirect_url is present" do
      flatpage = create :flatpage, redirect_url: "http://google.com"
      get :show, flatpage_path: flatpage.path
      response.should be_redirect
    end
    
    it "renders application layout by default" do
      flatpage = create :flatpage
      get :show, flatpage_path: flatpage.path
      response.should render_template(layout: "layouts/application")
    end
    
    it "render no_sidebar if show_sidebar is false" do
      flatpage = create :flatpage, show_sidebar: false
      get :show, flatpage_path: flatpage.path
      response.should render_template(layout: "layouts/app_nosidebar")
    end
    
    it "does not render a template if render_as_template is true" do
      flatpage = create :flatpage, render_as_template: true
      get :show, flatpage_path: flatpage.path
      response.should render_template(layout: false)
    end
  end
end
