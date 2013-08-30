require "spec_helper"

describe Concern::Associations::AudioAssociation do
  it "orders properly" do
    story = build :test_class_story
    story.audio.to_sql.should match /order by position/i
  end

  describe "#should_reject_audio?" do
    it "is true if all of the attributes are blank" do
      attributes = {
        'mp3'          => '',
        'enco_number'  => '',
        'enco_date'    => '',
        'external_url' => '',
        'description'  => '',
        'byline'       => ''
      }

      story = build :test_class_story
      story.send(:should_reject_audio?, attributes).should eq true
    end

    it "is false if any of the attributes are present" do
      attributes = {
        'mp3'          => '',
        'enco_number'  => '999',
        'enco_date'    => '',
        'external_url' => '',
        'description'  => 'Cool Audio',
        'byline'       => ''
      }

      story = build :test_class_story
      story.send(:should_reject_audio?, attributes).should eq false
    end
  end

  describe 'versioning' do
    it 'adds a version when adding to the collection' do
      story = create :test_class_story
      audio1 = build :direct_audio, content: nil
      audio2 = build :direct_audio, content: nil
      story.audio = [audio1, audio2]
      story.save!

      versions = story.versions
      versions.size.should eq 2

      versions.last.object_changes["audio"][0].should be_empty
      versions.last.object_changes["audio"][1].size.should eq 2
    end

    it "adds a version when removing from the collection" do
      story = create :test_class_story
      audio1 = build :direct_audio, content: nil
      audio2 = build :direct_audio, content: nil
      story.audio = [audio1, audio2]
      story.save!

      story.audio = []
      story.save!

      versions = story.versions
      versions.last.object_changes["audio"][0].size.should eq 2
      versions.last.object_changes["audio"][1].should be_empty
    end
  end
end
