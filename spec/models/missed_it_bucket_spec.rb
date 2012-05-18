require "spec_helper"

describe MissedItBucket do
  it { should have_many(:contents).class_name("MissedItContent") }
end
