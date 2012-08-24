require "spec_helper"

describe MissedItBucket do
  it { should have_many(:contents).class_name("MissedItContent") }
  it { should respond_to :obj_key }
end
