require "spec_helper"

describe ContentEmailController do
  describe "GET /new" do
    let(:content) { create :news_story }
    
    it "renders `minimal` layout" do
      get :new, obj_key: content.obj_key
      response.should render_with_layout 'minimal'
    end
    
    it "sets @message to a new ContentEmail object" do
      get :new, obj_key: content.obj_key
      assigns(:message).should be_a ContentEmail
    end
    
    it "assigns @content to an object based on the :obj_key" do
      get :new, obj_key: content.obj_key
      assigns(:content).should eq content
    end
    
    it "raises 404 if content isnt found" do
      -> { get :new }.should raise_error ActionController::RoutingError
      -> { get :new, obj_key: "wrong" }.should raise_error ActionController::RoutingError
    end
  end
  
  #-------------------
  
  describe "POST /create" do
    let(:content)  { create :news_story }
    
    before :each do
      post :create, 
            obj_key:        content.obj_key,
            content_email:  { name: "Bryan", email: "bricker@scpr.org" }
    end

    it "initializes a new ContentEmail with the form params" do
      message = assigns(:message)
      message.should be_a ContentEmail
      message.name.should eq "Bryan"
      message.email.should eq "bricker@scpr.org"
    end
    
    it "sets @message.content to @content" do
      assigns(:message).content.should eq content
    end
    
    context "valid message" do
      it "renders the success template" do
        response.should render_template "success"
      end
    end
    
    context "invalid message" do
      before :each do
        post :create, 
              obj_key:        content.obj_key,
              content_email:  { email: "invalid" }
      end
      
      it "sets the flash alert" do
        controller.should set_the_flash[:alert]
      end
      
      it "renders the new template" do
        response.should render_template 'new'
      end
      
      it "sets @content" do
        assigns(:content).should_not be_nil
      end
    end
  end
end