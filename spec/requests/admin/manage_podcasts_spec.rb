require "spec_helper"

describe Podcast do
  let(:valid_record) { build :podcast, is_listed: true }
  let(:updated_record) { build :podcast, is_listed: true }
  let(:invalid_record) { build :podcast, is_listed: true, title: "" }
  
  it_behaves_like "managed resource"
  it_behaves_like "save options"
  it_behaves_like "admin routes"
  it_behaves_like "versioned model"
  it_behaves_like "front-end routes"
end
