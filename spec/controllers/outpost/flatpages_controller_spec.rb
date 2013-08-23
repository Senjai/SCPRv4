require "spec_helper"

describe Outpost::FlatpagesController do
  it_behaves_like "resource controller" do
    let(:resource) { :flatpage }
  end

  describe "preview" do
    render_views 
    
    before :each do
      @current_user = create :admin_user
      controller.stub(:current_user) { @current_user }
    end
    
    context "existing object" do
      it "builds the object from existing attributes and assigns new ones" do
        flatpage = create :flatpage, title: "This is a story"
        put :preview, id: flatpage.id, obj_key: flatpage.obj_key, flatpage: flatpage.attributes.merge(title: "Updated")
        assigns(:flatpage).should eq flatpage
        assigns(:flatpage).title.should eq "Updated"
        response.should render_template "/flatpages/_flatpage"
      end

      it "notifies that there will be a redirect if the flatpage is a redirect" do
        flatpage = create :flatpage, redirect_to: "http://google.com/sweet_redirect_bro"
        put :preview, id: flatpage.id, obj_key: flatpage.obj_key, flatpage: flatpage.attributes
        response.body.should match /#{flatpage.redirect_url}/
      end

      it "renders the correct layout" do
        flatpage = create :flatpage, template: "full"
        put :preview, id: flatpage.id, obj_key: flatpage.obj_key, flatpage: flatpage.attributes
        response.should render_template "/outpost/preview/app_nosidebar"
        flatpage.template = "none"
        put :preview, id: flatpage.id, obj_key: flatpage.obj_key, flatpage: flatpage.attributes
        response.should render_template false
      end

      it "renders validation errors if the object is not unconditionally valid" do
        flatpage = create :flatpage
        put :preview, id: flatpage.id, obj_key: flatpage.obj_key, flatpage: flatpage.attributes.merge(path: "")
        response.should render_template "/outpost/shared/_preview_errors"
      end
    end

    context "new object" do
      it "builds a new object and assigns the attributes" do
        flatpage = build :flatpage, title: "This is a story"
        post :preview, obj_key: flatpage.obj_key, flatpage: flatpage.attributes
        assigns(:flatpage).title.should eq "This is a story"
        response.should render_template "/flatpages/_flatpage"
      end

      it "notifies that there will be a redirect if the flatpage is a redirect" do
        flatpage = build :flatpage, redirect_to: "http://google.com/sweet_redirect_bro"
        post :preview, obj_key: flatpage.obj_key, flatpage: flatpage.attributes
        response.body.should match /#{flatpage.redirect_to}/
      end

      it "renders validation errors if the object is not unconditionally valid" do
        flatpage = build :flatpage
        post :preview, obj_key: flatpage.obj_key, flatpage: flatpage.attributes.merge(path: "")
        response.should render_template "/outpost/shared/_preview_errors"
      end
    end
  end
end
