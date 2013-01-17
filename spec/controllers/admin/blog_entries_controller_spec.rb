require "spec_helper"

describe Admin::BlogEntriesController do
  it_behaves_like "resource controller" do
    let(:resource) { :blog_entry }
  end
  
  describe "preview" do
    render_views 
    
    before :each do
      @admin_user = create :admin_user
      controller.stub(:admin_user) { @admin_user }
    end
    
    it "previews the object", focus: true do
      entry = create :blog_entry
      put :preview, id: entry.id, obj_key: entry.obj_key, blog_entry: entry.attributes
      assigns(:entry).should eq entry
    end
  end
end
