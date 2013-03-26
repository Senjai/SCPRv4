require "spec_helper"

describe Outpost::OtherProgramsController do
  it_behaves_like "resource controller" do
    let(:resource) { :other_program }
  end
end
