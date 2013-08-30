require "spec_helper"

describe Concern::Associations::RelatedLinksAssociation do
  describe '#get_link' do
    it "finds the link with the requested type" do
      story = build :test_class_story
      story.related_links.build(title: "RSS", url: "rss.com/airtalk", link_type: "rss")
      story.get_link("rss").should eq "rss.com/airtalk"
    end
  end

  describe 'versioning' do
    it 'creates a version when saving the parent object', focus: true do
      story = create :test_class_story
      link1 = build :related_link, content: nil
      link2 = build :related_link, content: nil
      story.related_links = [link1, link2] # calls save on story... :(

      versions = story.versions
      versions.size.should eq 2

      versions.last.object_changes["related_links"][0].should be_empty
      versions.last.object_changes["related_links"][1].should be_present
    end
  end
end
