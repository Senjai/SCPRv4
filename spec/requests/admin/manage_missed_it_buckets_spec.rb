require "spec_helper"

describe MissedItBucket do
  let(:valid_record) { build :missed_it_bucket }
  let(:updated_record) { build :missed_it_bucket }
  let(:invalid_record) { build :missed_it_bucket, title: "" }
  
  it_behaves_like "managed resource"
  it_behaves_like "versioned model"
end
