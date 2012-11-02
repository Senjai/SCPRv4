require "spec_helper"

describe SectionsController do
  render_views
  
  describe "GET /show" do
    context "slug not found" do
      it "raises 404" do
        -> {
          get :show, slug: "nothing"
        }.should raise_error ActiveRecord::RecordNotFound
      end
    end
    
    context "valid section" do
      let(:section) { create :section, slug: "politics" }
      
      context "html request" do
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
      
      context "xml request" do
        it "returns an XML response" do
          get :show, slug: section.slug, format: :xml
          response.should render_template "sections/show"
          response.header['Content-Type'].should match /xml/
        end
      end
    end
  end
end
