require "spec_helper"

describe Outpost::MissedItBucketsController do
  it_behaves_like "resource controller" do
    let(:resource) { :missed_it_bucket }
  end
end
