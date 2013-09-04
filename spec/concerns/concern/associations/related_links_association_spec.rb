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
    it 'makes the object dirty' do
      story = create :test_class_story
      link1 = build :related_link, content: nil

      story.changed?.should eq false
      story.related_links << link1
      story.changed?.should eq true
    end

    it 'creates a version on the parent object when adding' do
      story = create :test_class_story
      link1 = build :related_link, content: nil
      link2 = build :related_link, content: nil

      story.related_links = [link1, link2]
      story.save!

      versions = story.versions
      versions.size.should eq 2

      versions.last.object_changes["related_links"][0].should be_empty
      versions.last.object_changes["related_links"][1].size.should eq 2
    end

    it "creates a version on the parent object when removing" do
      story = create :test_class_story
      link1 = build :related_link, content: nil
      link2 = build :related_link, content: nil

      story.versions.count.should eq 1

      story.related_links = [link1, link2]
      story.save!
      story.versions.count.should eq 2

      story.related_links = []
      story.save!
      story.versions.count.should eq 3

      versions = story.versions

      versions.last.object_changes["related_links"][0].size.should eq 2
      versions.last.object_changes["related_links"][1].should be_empty
    end
  end
end
