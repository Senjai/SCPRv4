require "spec_helper"

describe PijQuery do
  let(:valid_record) { build :pij_query, :published }
  let(:updated_record) { build :pij_query, :published }
  let(:invalid_record) { build :pij_query, headline: "" }
  
  it_behaves_like "managed resource"
  it_behaves_like "save options"
  it_behaves_like "admin routes"
  it_behaves_like "versioned model"
  it_behaves_like "front-end routes"
end
