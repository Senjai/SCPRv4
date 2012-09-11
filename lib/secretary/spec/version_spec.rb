require Rails.root.join("lib/secretary/spec/spec_helper")

describe Secretary::Version do
  it { should belong_to(:versioned) }
  it { should belong_to(:user).class_name("::User") }
  
  #------------------
  
  describe "#object" do
    it "should load in the serialized object with YAML" do
      story   = Secretary::Test::Story.create(headline: "Cool story, bro", body: load_response_fixture_file("long_text.txt"))
      user    = User.create(name: "Bryan")
      version = Secretary::Version.new(versioned: story, version_number: "1", user: user, description: "Updates", object_yaml: story.to_yaml)
      
      YAML.should_receive(:load).with(version.object_yaml).and_return "Loaded Yaml"
      version.object.should eq "Loaded Yaml"
    end
    
    it "returns a model object" do
      story   = Secretary::Test::Story.create(headline: "Cool story, bro", body: load_response_fixture_file("long_text.txt"))
      user    = User.create(name: "Bryan")
      version = Secretary::Version.new(versioned: story, version_number: "1", user: user, description: "Updates", object_yaml: story.to_yaml)
      
      version.object.should eq story
    end
  end
  
  #------------------
  
  describe "#increment_version_number" do
    it "sets version_number to 1 if no other versions exist for this object" do
      story = Secretary::Test::Story.create(headline: "Cool story, bro", body: load_response_fixture_file("long_text.txt"))
      story.update_attributes(headline: "Cooler story, bro.")
      story.versions.last.version_number.should eq 1
    end
    
    it "increments version number of version numbers already exist" do
      story = Secretary::Test::Story.create(headline: "Cool story, bro", body: load_response_fixture_file("long_text.txt"))
      story.update_attributes(headline: "Cooler story, bro.")
      story.update_attributes(headline: "Coolest story, bro!")
      story.versions.last.version_number.should eq 2
    end
  end
  
  #------------------
  
  describe "::generate" do
    it "generates a new version for passed-in object" do
      user        = User.create(name: "Bryan")
      story       = Secretary::Test::Story.create(headline: "Cool story, bro", body: "Cool text, bro.", logged_user_id: user.id)
      yaml        = story.to_yaml
      
      story.versions.size.should eq 0
      
      story.update_attributes(headline: "Cooler story, bro", body: "Coolio text")
      story.reload
      story.versions.size.should eq 1
      story.versions.last.object.headline.should_not eq story.headline
      story.versions.last.object_yaml.should eq yaml
    end
  end
  
  #------------------
  
  describe "::generate_description" do
    it "generates a description with the changed attributes" do
      user           = User.new(name: "Bryan Ricker")
      story          = Secretary::Test::Story.create(headline: "Cool story, bro", body: "Cool text, bro.", logged_user_id: user.id)
      story.headline = "Cooler story, bro"
      story.body     = "Sweet text, bro"
     
      story.changed_attributes.keys.should eq ["headline", "body"]
      Secretary::Version.generate_description(story).should eq "Changed headline, body"
    end
  end
  
  #------------------
  
  describe "::compare" do
    
  end
end
