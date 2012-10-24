require "spec_helper"

describe Event do
  let(:valid_record) { build :event, :published }
  let(:updated_record) { build :event, :published }
  let(:invalid_record) { build :event, :published, headline: "" }
  
  it_behaves_like "managed resource"
  it_behaves_like "save options"
  it_behaves_like "admin routes"
  it_behaves_like "versioned model"
  it_behaves_like "front-end routes"
end
