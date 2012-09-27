require "spec_helper"

describe Section do
  it_behaves_like "managed resource" do
    let(:valid_record) { build :section }
    let(:updated_record) { build :section }
    let(:invalid_record) { build :section, title: "" }
  end
  
  it_behaves_like "versioned model" do
    let(:valid_record) { build :section }
    let(:updated_record) { build :section }
  end
end
