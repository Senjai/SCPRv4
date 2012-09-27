require "spec_helper"

describe Blog do
  it_behaves_like "managed resource" do
    let(:valid_record) { build :blog }
    let(:updated_record) { build :blog }
    let(:invalid_record) { build :blog, name: "" }
  end
    
  it_behaves_like "versioned model" do
    let(:valid_record) { build :blog }
    let(:updated_record) { build :blog }
  end
end
