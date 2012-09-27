require "spec_helper"

describe Bio do
  it_behaves_like "managed resource" do
    let(:valid_record) { build :bio }
    let(:updated_record) { build :bio }
    let(:invalid_record) { build :bio, name: "", title: "" }
  end
  
  it_behaves_like "versioned model" do
    let(:valid_record) { build :bio }
    let(:updated_record) { build :bio }
  end
end
