require "spec_helper"

describe Flatpage do
  let(:valid_record) { build :flatpage }
  let(:updated_record) { build :flatpage }
  let(:invalid_record) { build :flatpage, path: "" }
  
  it_behaves_like "managed resource"
  it_behaves_like "save options"
  it_behaves_like "admin routes"
  it_behaves_like "versioned model"
  it_behaves_like "front-end routes" do
    before :each do
      valid_record.save!
    end
  end
end
