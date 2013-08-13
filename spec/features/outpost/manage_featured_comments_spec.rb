require "spec_helper"

describe FeaturedComment do
  let(:valid_record) { build :featured_comment, :published }
  let(:updated_record) { build :featured_comment, :published }
  let(:invalid_record) { build :featured_comment, :published, username: "" }

  it_behaves_like "managed resource"
  it_behaves_like "save options"
  it_behaves_like "admin routes"
  it_behaves_like "versioned model"
end
