require "spec_helper"

describe Outpost::ShowSegmentsController do
  it_behaves_like "resource controller" do
    let(:resource) { :show_segment }
  end

  describe "preview" do
    render_views 
    
    before :each do
      @current_user = create :admin_user
      controller.stub(:current_user) { @current_user }
    end
    
    context "existing object" do
      it "builds the object from existing attributes and assigns new ones" do
        show_segment = create :show_segment, headline: "This is a story"
        put :preview, id: show_segment.id, obj_key: show_segment.obj_key, show_segment: show_segment.attributes.merge(headline: "Updated")
        assigns(:segment).should eq show_segment
        assigns(:segment).headline.should eq "Updated"
        response.should render_template "/programs/_segment"
      end

      it "renders validation errors if the object is not unconditionally valid" do
        show_segment = create :show_segment, headline: "Okay"
        put :preview, id: show_segment.id, obj_key: show_segment.obj_key, show_segment: show_segment.attributes.merge(headline: "")
        response.should render_template "/outpost/shared/_preview_errors"
      end
    end

    context "new object" do
      it "builds a new object and assigns the attributes" do
        show_segment = build :show_segment, headline: "This is a story"
        post :preview, obj_key: show_segment.obj_key, show_segment: show_segment.attributes
        assigns(:segment).headline.should eq "This is a story"
        response.should render_template "/programs/_segment"
      end

      it "renders validation errors if the object is not unconditionally valid" do
        show_segment = build :show_segment, headline: "okay"
        post :preview, obj_key: show_segment.obj_key, show_segment: show_segment.attributes.merge(headline: "")
        response.should render_template "/outpost/shared/_preview_errors"
      end
    end
  end
end
