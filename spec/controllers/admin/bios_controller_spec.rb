require "spec_helper"

describe Admin::BiosController do
  it_behaves_like "resource controller" do
    let(:resource) { :bio }
  end
end
