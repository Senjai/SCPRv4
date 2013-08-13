require "spec_helper"

describe ShowSegment do
  let(:valid_record) { build :show_segment, :published }
  let(:updated_record) { build :show_segment, :published }
  let(:invalid_record) { build :show_segment, :published, headline: "" }

  it_behaves_like "managed resource"
  it_behaves_like "save options"
  it_behaves_like "admin routes"
  it_behaves_like "versioned model"
  it_behaves_like "front-end routes"
end
