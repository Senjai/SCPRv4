require "spec_helper"

describe BlogCategory do
  it { should belong_to(:blog) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:slug) }
end
  