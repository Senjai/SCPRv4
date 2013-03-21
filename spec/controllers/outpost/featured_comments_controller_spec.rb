require "spec_helper"

describe Outpost::FeaturedCommentsController do
  it_behaves_like "resource controller" do
    let(:resource) { :featured_comment }
  end
end
