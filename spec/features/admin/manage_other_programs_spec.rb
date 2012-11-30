require "spec_helper"

describe OtherProgram do
  let(:valid_record)   { build :other_program }
  let(:updated_record) { build :other_program }
  let(:invalid_record) { build :other_program, title: "" }
  
  it_behaves_like "managed resource"
  it_behaves_like "save options"
  it_behaves_like "admin routes"
  it_behaves_like "versioned model"
  it_behaves_like "front-end routes"
end
