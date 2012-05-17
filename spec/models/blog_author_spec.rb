require "spec_helper"

describe BlogAuthor do
  it { should belong_to(:author).class_name("Bio") }
  it { should belong_to(:blog) }
end