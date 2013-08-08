require "spec_helper"

describe Api::Public::V3::ProgramsController do
  request_params = {
    :format => :json
  }

  render_views

  describe "GET show" do
    it "finds the object if it exists" do
      program = create :kpcc_program, slug: 'hello'
      get :show, { id: program.slug }.merge(request_params)
      assigns(:program).should eq program.to_program
      response.should render_template "show"
    end

    it "returns a 404 status if it does not exist" do
      get :show, { id: "nonono" }.merge(request_params)
      response.response_code.should eq 404
      response.body.should eq Hash[error: "Not Found"].to_json
    end
  end

  describe "GET index" do
    it "returns all KPCC programs and Other Programs combined" do
      kpcc_program       = create :kpcc_program
      external_program   = create :external_program

      get :index, request_params
      assigns(:programs).should eq [kpcc_program, external_program].map(&:to_program)
    end
  end
end
