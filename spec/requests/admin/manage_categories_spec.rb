require "spec_helper"

describe Category do
  let(:valid_record) { build :category, :is_news }
  let(:updated_record) { build :category, :is_news }
  let(:invalid_record) { build :category, title: "" }
  
  it_behaves_like "managed resource"
  it_behaves_like "save options"
  it_behaves_like "admin routes"
  it_behaves_like "versioned model"
  it_behaves_like "front-end routes"
end
