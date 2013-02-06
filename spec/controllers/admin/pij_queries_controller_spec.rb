require "spec_helper"

describe Admin::PijQueriesController do
  it_behaves_like "resource controller" do
    let(:resource) { :pij_query }
  end

  describe "preview" do
    render_views 
    
    before :each do
      @admin_user = create :admin_user
      controller.stub(:admin_user) { @admin_user }
    end
    
    context "existing object" do
      it "builds the object from existing attributes and assigns new ones" do
        pij_query = create :pij_query, headline: "This is a story"
        put :preview, id: pij_query.id, obj_key: pij_query.obj_key, pij_query: pij_query.attributes.merge(headline: "Updated")
        assigns(:query).should eq pij_query
        assigns(:query).headline.should eq "Updated"
        response.should render_template "/pij_queries/_pij_query"
      end

      it "renders validation errors if the object is not unconditionally valid" do
        pij_query = create :pij_query, headline: "Okay"
        put :preview, id: pij_query.id, obj_key: pij_query.obj_key, pij_query: pij_query.attributes.merge(headline: "")
        response.should render_template "/admin/shared/_preview_errors"
      end
    end

    context "new object" do
      it "builds a new object and assigns the attributes" do
        pij_query = build :pij_query, headline: "This is a story"
        post :preview, obj_key: pij_query.obj_key, pij_query: pij_query.attributes
        assigns(:query).headline.should eq "This is a story"
        response.should render_template "/pij_queries/_pij_query"
      end

      it "renders validation errors if the object is not unconditionally valid" do
        pij_query = build :pij_query, headline: "okay"
        post :preview, obj_key: pij_query.obj_key, pij_query: pij_query.attributes.merge(headline: "")
        response.should render_template "/admin/shared/_preview_errors"
      end
    end
  end
end
