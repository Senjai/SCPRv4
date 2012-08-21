require "spec_helper"

describe SectionCategory do
  it { should belong_to(:category) }
  it { should belong_to(:section) }
end
