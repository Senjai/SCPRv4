require "spec_helper"

describe Outpost::SectionsController do
  it_behaves_like "resource controller" do
    let(:resource) { :section }
  end
end
