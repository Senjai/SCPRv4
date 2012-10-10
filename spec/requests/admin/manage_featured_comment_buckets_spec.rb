require "spec_helper"

describe FeaturedCommentBucket do
  let(:valid_record) { build :featured_comment_bucket }
  let(:updated_record) { build :featured_comment_bucket }
  let(:invalid_record) { build :featured_comment_bucket, title: "" }
  
  it_behaves_like "managed resource"
  it_behaves_like "versioned model"
end
