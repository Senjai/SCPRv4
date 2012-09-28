require "spec_helper"

describe Bio do  
  let(:valid_record)   { build :bio }
  let(:updated_record) { build :bio }
  let(:invalid_record) { build :bio, name: "", title: "" }
  
  it_behaves_like "managed resource"
  it_behaves_like "versioned model"

# sphinx...
#  it_behaves_like "front-end routes request" do
#    sphinx_spec(num: 1)
#  end
end
