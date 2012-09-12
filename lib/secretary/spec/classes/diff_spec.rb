require File.expand_path("../../spec_helper", __FILE__)

describe Secretary::Diff do
  let(:story) { Secretary::Test::Story.create(headline: "Story Draft", body: "text text text") }
  
  before :each do
    user = User.create(name: "Bryan")
    Secretary::Test::Story.any_instance.stub(:logged_user_id).and_return(user.id)
  end

  it "returns a Diff object with only the changed attributes" do
    story.update_attributes(headline: "Story Edits")
    story.update_attributes(body: "edited text")
    story.update_attributes(headline: "Story Published", body: "final text")
    
    diff1 = Secretary::Diff.new(story.versions[0], story.versions[1])
    diff1.keys.should eq ["headline"]
  
    diff2 = Secretary::Diff.new(story.versions[1], story.versions[2])
    diff2.keys.should eq ["body"]
  end
  
  it "ignores the attributes in IGNORE" do
    stub_const("Secretary::Diff::IGNORE", ["updated_at"])
    
    story.update_attributes(headline: "Story Edits!")
    diff = Secretary::Diff.new(story.versions[0], story.versions[1])
    diff.keys.should_not include "updated_at"
    diff.keys.should_not include :updated_at
  end
end
