require "spec_helper"

describe Blog do
  let(:valid_record) { build :blog }
  let(:updated_record) { build :blog }
  let(:invalid_record) { build :blog, name: "" }

  it_behaves_like "managed resource"
  it_behaves_like "versioned model"
  it_behaves_like "front-end routes request"
end
