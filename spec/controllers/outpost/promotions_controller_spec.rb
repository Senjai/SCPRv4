require "spec_helper"

describe Outpost::PromotionsController do
  it_behaves_like "resource controller" do
    let(:resource) { :promotion }
  end
end