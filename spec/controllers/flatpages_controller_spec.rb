require "spec_helper"

describe FlatpagesController do  
  describe "GET show" do
    it "responds with success" do
      flatpage = create :flatpage
      get :show, id: flatpage.id
      response.should be_success
    end
    
    it "assigns @flatpage" do
      flatpage = create :flatpage
      get :show, id: flatpage.id
      assigns(:flatpage).should eq flatpage
    end
    
    it "renders application layout by default" do
      flatpage = create :flatpage
      get :show, id: flatpage.id
      response.should render_template(layout: "layouts/application")
    end
    
    it "render no_sidebar if show_sidebar is false" do
      flatpage = create :flatpage, show_sidebar: false
      get :show, id: flatpage.id
      response.should render_template(layout: "layouts/app_nosidebar")
    end
    
    it "does not render a template if render_as_template is true" do
      flatpage = create :flatpage, render_as_template: true
      get :show, id: flatpage.id
      response.should render_template(layout: false)
    end
  end
end
