require "spec_helper"

describe Admin::ShowSegmentsController do
  it_behaves_like "resource controller" do
    let(:resource) { :show_segment }
  end
end