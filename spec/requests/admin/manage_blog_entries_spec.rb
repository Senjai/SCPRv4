require "spec_helper"

describe BlogEntry do
  it_behaves_like "managed resource" do
    let(:valid_record) { build :blog_entry, :published }
    let(:updated_record) { build :blog_entry, :published }
    let(:invalid_record) { build :blog_entry, status: ContentBase::STATUS_LIVE, headline: "" }
  end
  
  it_behaves_like "versioned model" do
    let(:valid_record) { build :blog_entry, :published }
    let(:updated_record) { build :blog_entry, :published }
  end
end
