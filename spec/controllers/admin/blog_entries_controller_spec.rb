require "spec_helper"

describe Outpost::BlogEntriesController do
  it_behaves_like "resource controller" do
    let(:resource) { :blog_entry }
  end
  
  describe "preview" do
    render_views 
    
    before :each do
      @admin_user = create :admin_user
      controller.stub(:admin_user) { @admin_user }
    end
    
    context "existing object" do
      it "builds the object from existing attributes and assigns new ones" do
        entry = create :blog_entry, headline: "This is a blog entry"
        put :preview, id: entry.id, obj_key: entry.obj_key, blog_entry: entry.attributes.merge(headline: "Updated")
        assigns(:entry).should eq entry
        assigns(:entry).headline.should eq "Updated"
        response.should render_template "/blogs/_entry"
      end

      it "renders validation errors if the object is not unconditionally valid" do
        entry = create :blog_entry, headline: "Okay"
        put :preview, id: entry.id, obj_key: entry.obj_key, blog_entry: entry.attributes.merge(headline: "")
        response.should render_template "/outpost/shared/_preview_errors"
      end
    end

    context "new object" do
      it "builds a new object and assigns the attributes" do
        entry = build :blog_entry, headline: "This is a blog entry"
        post :preview, obj_key: entry.obj_key, blog_entry: entry.attributes
        assigns(:entry).headline.should eq "This is a blog entry"
        response.should render_template "/blogs/_entry"
      end

      it "renders validation errors if the object is not unconditionally valid" do
        entry = build :blog_entry, headline: "okay"
        post :preview, obj_key: entry.obj_key, blog_entry: entry.attributes.merge(headline: "")
        response.should render_template "/outpost/shared/_preview_errors"
      end
    end
  end
end
