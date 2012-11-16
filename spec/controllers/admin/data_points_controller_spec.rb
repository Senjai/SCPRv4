require "spec_helper"

describe Admin::DataPointsController do
  it_behaves_like "resource controller" do
    let(:resource) { :data_point }
  end
end
