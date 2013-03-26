require "spec_helper"

describe Outpost::KpccProgramsController do
  it_behaves_like "resource controller" do
    let(:resource) { :kpcc_program }
  end
end
