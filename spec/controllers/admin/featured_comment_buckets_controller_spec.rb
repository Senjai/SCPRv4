require "spec_helper"

describe Admin::FeaturedCommentBucketsController do
  it_behaves_like "resource controller" do
    let(:resource) { :featured_comment_bucket }
  end
end
