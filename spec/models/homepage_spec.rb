require "spec_helper"

describe Homepage do
  it { should belong_to(:missed_it_bucket) }
  it { should have_many(:content).class_name("HomepageContent") }
end