require "spec_helper"

describe Section do
  let(:valid_record) { build :section }
  let(:updated_record) { build :section }
  let(:invalid_record) { build :section, title: "" }
  
  it_behaves_like "managed resource"
  it_behaves_like "versioned model"
  it_behaves_like "front-end routes request" do
    before :each do
      valid_record.save!
      Scprv4::Application.reload_routes!
    end
  end
end
