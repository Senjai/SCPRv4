require "spec_helper"

describe Outpost::ExternalProgramsController do
  it_behaves_like "resource controller" do
    let(:resource) { :external_program }
  end
end
