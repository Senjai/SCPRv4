require "spec_helper"

describe KpccProgram do
  let(:valid_record)   { build :kpcc_program }
  let(:updated_record) { build :kpcc_program }
  let(:invalid_record) { build :kpcc_program, title: "" }
  
  it_behaves_like "managed resource"
  it_behaves_like "versioned model"
  it_behaves_like "front-end routes request"
end
