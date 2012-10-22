require "spec_helper"

describe DataPoint do
  let(:valid_record) { build :data_point }
  let(:updated_record) { build :data_point }
  let(:invalid_record) { build :data_point, data_key: nil }
  
  it_behaves_like "managed resource"
  it_behaves_like "versioned model"
end
