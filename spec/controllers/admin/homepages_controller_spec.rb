require "spec_helper"

describe Admin::HomepagesController do
  describe "preview" do
    render_views 
    
    before :each do
      @admin_user = create :admin_user
      controller.stub(:admin_user) { @admin_user }
    end
    
    context "existing object" do
      it "builds the object from existing attributes and assigns new ones" do
        homepage = create :homepage, base: "default"
        put :preview, id: homepage.id, obj_key: homepage.obj_key, homepage: homepage.attributes.merge(base: "lead_right")
        assigns(:homepage).should eq homepage
        assigns(:homepage).base.should eq "lead_right"
        response.should render_template "/admin/homepages/previews/lead_right"
      end

      it "renders validation errors if the object is not unconditionally valid" do
        homepage = create :homepage
        put :preview, id: homepage.id, obj_key: homepage.obj_key, homepage: homepage.attributes.merge(base: "")
        response.should render_template "/admin/shared/_preview_errors"
      end
    end

    context "new object" do
      it "builds a new object and assigns the attributes" do
        homepage = build :homepage, base: "default"
        post :preview, obj_key: homepage.obj_key, homepage: homepage.attributes
        assigns(:homepage).base.should eq "default"
        response.should render_template "/admin/homepages/previews/#{homepage.base}"
      end

      it "renders validation errors if the object is not unconditionally valid" do
        homepage = build :homepage
        post :preview, obj_key: homepage.obj_key, homepage: homepage.attributes.merge(base: "")
        response.should render_template "/admin/shared/_preview_errors"
      end
    end
  end
end
