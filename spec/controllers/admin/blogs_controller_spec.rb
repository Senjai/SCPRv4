require "spec_helper"

describe Admin::BlogsController do
  it_behaves_like "resource controller" do
    let(:resource) { :blog }
  end
end
