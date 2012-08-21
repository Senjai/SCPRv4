require "spec_helper"

describe SectionBlog do
  it { should belong_to(:section) }
  it { should belong_to(:blog) }
end