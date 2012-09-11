require "spec_helper"

describe Secretary::HasSecretary do
  describe "has_secretary" do
    let(:new_story)   { Secretary::Test::Story.new(headline: "Cool Story, Bro", body: "Some cool text.") }
    let(:other_story) { Secretary::Test::Story.create(headline: "Cool Story, Bro", body: "Some cool text.") }
    
    it "adds the has_many association for versions" do
      new_story.should have_many(:versions).dependent(:destroy).class_name("Secretary::Version")
    end
    
    it "has logged_user" do
      new_story.should respond_to :logged_user_id
    end
    
    it "does not generate a version on create" do
      new_story.save!
      Secretary::Version.count.should eq 0
    end
    
    it "generates a version when a record is saved on update" do
      other_story.update_attributes(headline: "Some Cool Headline?!")
      Secretary::Version.count.should eq 1
      other_story.versions.size.should eq 1
    end
    
    it "stores the pre-change version of the object in @dirty" do
      pre_change = Secretary::Test::Story.find(other_story.id)
      other_story.headline = "Other cool headline"
      other_story.save!
      dirty = other_story.instance_variable_get(:@dirty)
      pre_change.headline.should_not eq other_story.headline
      dirty.headline.should eq pre_change.headline
    end
    
    it "sends to Version.generate on update" do
      Secretary::Version.should_receive(:generate).with(other_story)
      other_story.update_attributes(headline: "Some Cool Headline?!")
    end    
  end
end
