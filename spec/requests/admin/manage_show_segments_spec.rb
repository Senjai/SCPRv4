require "spec_helper"

describe ShowSegment do
  it_behaves_like "managed resource" do
    let(:valid_record) { build :show_segment, :published }
    let(:updated_record) { build :show_segment, :published }
    let(:invalid_record) { build :show_segment, status: ContentBase::STATUS_LIVE, headline: "" }
  end
  
  it_behaves_like "versioned model" do
    let(:valid_record) { build :show_segment, :published }
    let(:updated_record) { build :show_segment, :published }
  end
end
