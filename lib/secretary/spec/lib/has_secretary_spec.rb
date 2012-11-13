require File.expand_path("../../spec_helper", __FILE__)

describe Secretary::HasSecretary do
  describe "has_secretary?" do
    it "returns false if no has_secretary declared" do
      User.has_secretary?.should eq false
    end
    
    it "returns true if @_has_secretary is true" do
      User.instance_variable_set(:@_has_secretary, true)
      User.has_secretary?.should eq true
    end
  end
  
  #---------------
  
  describe "has_secretary" do
    before :each do
      user = User.create(name: "Bryan")
      Secretary::Test::Story.any_instance.stub(:logged_user_id).and_return(user.id)
    end
    
    let(:new_story)   { Secretary::Test::Story.new(headline: "Cool Story, Bro", body: "Some cool text.") }
    let(:other_story) { Secretary::Test::Story.create(headline: "Cooler Story, Bro", body: "Some cooler text.") }
    
    it "sets @has_secretary to true" do
      Secretary::Test::Story.instance_variable_get(:@_has_secretary).should eq true
      Secretary::Test::Story.has_secretary?.should eq true
    end
    
    it "adds the has_many association for versions" do
      new_story.should have_many(:versions).dependent(:destroy).class_name("Secretary::Version")
    end
    
    it "has logged_user_id" do
      new_story.should respond_to :logged_user_id
    end
    
    it "generates a version on create" do
      Secretary::Version.count.should eq 0
      new_story.save!
      Secretary::Version.count.should eq 1
      new_story.versions.count.should eq 1
    end
    
    
    it "generates a version when a record is saved on update" do
      other_story.update_attributes(headline: "Some Cool Headline?!")
      Secretary::Version.count.should eq 2
      other_story.versions.size.should eq 2
    end
    
    it "doesn't generate a version if no attributes were changed" do
      other_story.save!
      other_story.versions.size.should eq 1
      other_story.save!
      other_story.versions.size.should eq 1
    end
    
    it "saves the version that just got saved" do
      other_story.headline = "Other cool headline"
      other_story.save!
      other_story.versions.last.frozen_object.should eq other_story
    end
    
    it "sends to Version.generate on update" do
      Secretary::Version.should_receive(:generate).twice.with(other_story)
      other_story.update_attributes(headline: "Some Cool Headline?!")
    end
    
    it "destroys all versions when the object is destroyed" do
      other_story.update_attributes!(headline: "Changed the headline")
      other_story.versions.size.should eq 2
      Secretary::Version.count.should eq 2
      other_story.destroy
      Secretary::Version.count.should eq 0
    end
  end
end
