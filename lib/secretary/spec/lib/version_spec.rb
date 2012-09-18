require File.expand_path("../../spec_helper", __FILE__)

describe Secretary::Version do
  it { should belong_to(:versioned) }
  it { should belong_to(:user).class_name("::User") }
  it { should validate_presence_of :object_yaml }
  it { should validate_presence_of :versioned }
  
  #------------------
  
  before :each do
    user = User.create(name: "Bryan")
    Secretary::Test::Story.any_instance.stub(:logged_user_id).and_return(user.id)
  end

  describe "#frozen_object" do
    it "should load in the serialized object with YAML" do
      story   = Secretary::Test::Story.create(headline: "Cool story, bro", body: load_fixture("long_text.txt"))
      user    = User.create(name: "Bryan")
      version = Secretary::Version.new(versioned: story, version_number: "1", user: user, description: "Updates", object_yaml: story.to_yaml)
    
      YAML.should_receive(:load).with(version.object_yaml).and_return "Loaded Yaml"
      version.frozen_object.should eq "Loaded Yaml"
    end
  
    it "returns a model object" do
      story   = Secretary::Test::Story.create(headline: "Cool story, bro", body: load_fixture("long_text.txt"))
      user    = User.create(name: "Bryan")
      version = Secretary::Version.new(versioned: story, version_number: "1", user: user, description: "Updates", object_yaml: story.to_yaml)
    
      version.frozen_object.should eq story
    end
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

  describe "::generate" do
    it "generates a new version for passed-in object" do
      story   = Secretary::Test::Story.create(headline: "Cool story, bro", body: "Cool text, bro.")
      version = Secretary::Version.generate(story)
      story.versions.should include version
      
      yaml = story.to_yaml
      
      Secretary::Version.count.should eq 2
      story.update_attributes!(headline: "Something else")
      Secretary::Version.count.should eq 3
      
      story.update_attributes!(headline: "Cooler story, bro", body: "Coolio text")
      story.reload
      story.versions.size.should eq 4
      story.versions.last.frozen_object.headline.should eq story.headline
      story.versions.last.object_yaml.should_not eq yaml
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
