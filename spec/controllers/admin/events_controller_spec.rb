require "spec_helper"

describe Admin::EventsController do
  it_behaves_like "resource controller" do
    let(:resource) { :event }
  end

  describe "preview" do
    render_views 
    
    before :each do
      @admin_user = create :admin_user
      controller.stub(:admin_user) { @admin_user }
    end
    
    context "existing object" do
      it "builds the object from existing attributes and assigns new ones" do
        event = create :event, headline: "This is a story"
        put :preview, id: event.id, obj_key: event.obj_key, event: event.attributes.merge(headline: "Updated")
        assigns(:event).should eq event
        assigns(:event).headline.should eq "Updated"
        response.should render_template "/events/_event"
      end

      it "renders validation errors if the object is not unconditionally valid" do
        event = create :event, headline: "Okay"
        put :preview, id: event.id, obj_key: event.obj_key, event: event.attributes.merge(headline: "")
        response.should render_template "/admin/shared/_preview_errors"
      end
    end

    context "new object" do
      it "builds a new object and assigns the attributes" do
        event = build :event, headline: "This is a story"
        post :preview, obj_key: event.obj_key, event: event.attributes
        assigns(:event).headline.should eq "This is a story"
        response.should render_template "/events/_event"
      end

      it "renders validation errors if the object is not unconditionally valid" do
        event = build :event, headline: "okay"
        post :preview, obj_key: event.obj_key, event: event.attributes.merge(headline: "")
        response.should render_template "/admin/shared/_preview_errors"
      end
    end
  end
end
