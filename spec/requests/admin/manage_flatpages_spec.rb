require "spec_helper"

describe Flatpage do
  it_behaves_like "managed resource" do
    let(:valid_record) { build :flatpage }
    let(:updated_record) { build :flatpage }
    let(:invalid_record) { build :flatpage, url: "" }
  end
  
  it_behaves_like "versioned model" do
    let(:valid_record) { build :flatpage }
    let(:updated_record) { build :flatpage }
  end
end
