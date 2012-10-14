require "spec_helper"

describe Admin::PijQueriesController do
  it_behaves_like "resource controller" do
    let(:resource) { :pij_query }
  end
end