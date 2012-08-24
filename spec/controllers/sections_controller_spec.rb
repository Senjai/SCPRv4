require "spec_helper"

describe SectionsController do
  describe "GET /show" do
    context "slug not found" do
      it "raises 404" do
        -> {
          get :show, slug: "nothing"
        }.should raise_error ActionController::RoutingError
      end
    end
    
    context "valid section" do
      let(:section) { create :section, slug: "politics" }
      
      before :each do
        get :show, slug: section.slug
      end
      
      it "sets @section to the correct section" do
        assigns(:section).should eq section
      end
    
      it "sets content do the section's content" do
        assigns(:content).should eq section.content
      end
    end
  end
end
