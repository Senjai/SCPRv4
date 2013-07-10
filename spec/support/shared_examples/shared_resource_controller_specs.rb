# These just make sure there are no blatant view errors.
# Could definitely be faster and more useful.

shared_examples_for "resource controller" do
  render_views

  before :each do
    @object     = create resource
    @admin_user = create :admin_user
    controller.stub(:current_user) { @admin_user }
  end

  describe "GET /index" do
    it "responds with success" do
      get :index
      assigns(:records).should eq [@object]
      response.should be_success
    end
  end

  describe "GET /show" do
    it "redirects to edit" do
      get :show, id: @object.id
      assigns(:record).should eq @object
      response.should be_redirect
    end
  end

  describe "GET /new" do
    it "responds with success" do
      get :new
      response.should be_success
    end
  end

  describe "GET /edit" do
    it "responds with success" do
      get :edit, id: @object.id
      assigns(:record).should eq @object
      response.should be_success
    end
  end

  describe "POST /create" do
    it "creates the resource" do
      post :create, resource => build(resource).attributes
    end
  end

  describe "PUT /update" do
    it "gets the record" do
      put :update, id: @object.id, resource => build(resource).attributes
      assigns(:record).should eq @object
    end
  end

  describe "DELETE /destroy" do
    it "destroys the resource" do
      delete :destroy, id: @object.id
      assigns(:record).should eq @object
      response.should be_redirect
    end
  end
end
