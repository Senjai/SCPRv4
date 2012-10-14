require "spec_helper"

describe BlogEntry do
  let(:valid_record) { build :blog_entry, :published }
  let(:updated_record) { build :blog_entry, :published }
  let(:invalid_record) { build :blog_entry, status: ContentBase::STATUS_LIVE, headline: "" }
  
  it_behaves_like "managed resource"
  it_behaves_like "versioned model"
  it_behaves_like "front-end routes request"
end
