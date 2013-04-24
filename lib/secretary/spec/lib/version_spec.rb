require File.expand_path("../../spec_helper", __FILE__)

describe Secretary::Version do
  it { should belong_to(:versioned) }
  it { should belong_to(:user).class_name("::User") }
  it { should validate_presence_of(:versioned) }
  
  #------------------
  
  before :each do
    user = User.create(name: "Bryan")
    Secretary::Test::Story.any_instance.stub(:logged_user_id).and_return(user.id)
  end

  #------------------

  describe "#increment_version_number" do
    it "sets version_number to 1 if no other versions exist for this object" do
      story = Secretary::Test::Story.create(headline: "Cool story, bro", body: load_fixture("long_text.txt"))
      story.versions.last.version_number.should eq 1
    end
  
    it "increments version number if versions already exist" do
      story = Secretary::Test::Story.create(headline: "Cool story, bro", body: load_fixture("long_text.txt"))
      story.versions.last.version_number.should eq 1
      story.update_attributes(headline: "Cooler story, bro.")
      story.versions.last.version_number.should eq 2
      story.update_attributes(headline: "Coolest story, bro!")
      story.versions.last.version_number.should eq 3
    end
  end

  #------------------

  describe '#attribute_diffs' do
    it 'is a hash of attribute keys, and Diffy::Diff objects' do
      story = Secretary::Test::Story.create(headline: "Cool story, bro", body: load_fixture("long_text.txt"))
      story.update_attributes!(headline: "Updated Headline")

      version = story.versions.last
      version.attribute_diffs.keys.should eq ["headline"]
      version.attribute_diffs["headline"].should be_a Diffy::Diff
    end
  end

  #------------------

  describe "::should_ignore?" do
    before :each do
      stub_const("Secretary::Version::IGNORE", ["id"])
    end
    
    it "returns true if IGNORE includes the passed-in string" do
      Secretary::Version.should_ignore?("id").should be_true
    end
    
    it "returns false if IGNORE does not include the passed-in string" do
      Secretary::Version.should_ignore?("body").should be_false
    end
  end

  #------------------

  describe "::generate" do
    it "generates a new version for passed-in object" do
      story   = Secretary::Test::Story.create(headline: "Cool story, bro", body: "Cool text, bro.")
      version = Secretary::Version.generate(story)
      story.versions.should include version
      
      Secretary::Version.count.should eq 2
    end
  end

  #------------------

  describe "::generate_description" do
    let(:story) { Secretary::Test::Story.create(headline: "Cool story, bro", body: "Cool text, bro.") }
    
    it "generates a description with object name on create" do
      story.stub(:action) { :create }
      Secretary::Version::generate_description(story).should eq "Created Story ##{story.id}"
    end
    
    it "generates a description with the changed attributes on update" do
      story.stub(:action) { :update }
      story.stub(:changed_attributes) { {"headline" => "anything", "body" => "anything else"} }
      Secretary::Version.generate_description(story).should eq "Changed headline and body"
    end
  end
end
