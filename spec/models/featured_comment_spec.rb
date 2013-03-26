require "spec_helper"

describe FeaturedComment do
  it "validates that the content exists" do
    comment = build :featured_comment, content_type: "Event", content_id: "999"
    comment.should_not be_valid
    comment.errors.keys.should eq [:content_id]
  end

  it "validates that the content is published" do
    story = create :news_story, :draft
    entry = create :blog_entry, :published

    comment1 = build :featured_comment, content: story
    comment2 = build :featured_comment, content: entry

    comment1.should_not be_valid
    comment1.errors.keys.should eq [:content_id]
    
    comment2.should be_valid
  end
end
