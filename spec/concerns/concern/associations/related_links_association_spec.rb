require "spec_helper"

describe Concern::Associations::RelatedLinksAssociation do
  describe '#get_link' do
    it "finds the link with the requested type" do
      story = build :test_class_story
      story.related_links.build(title: "RSS", url: "rss.com/airtalk", link_type: "rss")
      story.get_link("rss").should eq "rss.com/airtalk"
    end
  end
end
