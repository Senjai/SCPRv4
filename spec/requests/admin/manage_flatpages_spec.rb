require "spec_helper"

describe Flatpage do
  let(:valid_record) { build :flatpage }
  let(:updated_record) { build :flatpage }
  let(:invalid_record) { build :flatpage, url: "" }
  
  it_behaves_like "managed resource"
  it_behaves_like "versioned model"
  it_behaves_like "front-end routes request" do
    before :each do
      valid_record.save!
      Scprv4::Application.reload_routes!
    end
  end
end
