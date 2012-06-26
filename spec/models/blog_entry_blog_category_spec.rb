require "spec_helper"

describe BlogEntryBlogCategory do
  it { should belong_to(:blog_entry) }
  it { should belong_to(:blog_category) }
end