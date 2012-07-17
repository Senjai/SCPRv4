require "spec_helper"

describe AdminResource do
  it "extends AR::Base with the administrate class method" do
    ActiveRecord::Base.methods.should include :administrate
  end
  
  describe "list_fields" do    
    it "uses all of the model's columns if no list_fields are specified" do
      NewsStory.list_fields = nil
      NewsStory.list_fields.map { |f| f[0] }.should eq NewsStory.column_names
    end
    
    it "uses the passed-in fields if specified" do
      NewsStory.list_fields = [['id'], ['headline']]
      NewsStory.list_fields.map { |f| f[0] }.should eq ['id', 'headline']
    end
    
    it "converts attributes to strings" do
      NewsStory.list_fields = [[:id], [:headline]]
      NewsStory.list_fields.map { |f| f[0] }.should eq ['id', 'headline']
    end
      
    
    it "raises an error if an invalid attribute is passed into list field" do
      -> { NewsStory.list_fields = ['not_a_thing'] }.should raise_error
    end
    
    it "titleizes attributes if no title is specified" do
      NewsStory.list_fields = [['id'], ['headline']]
      NewsStory.list_fields.map { |f| f[1][:title] }.should eq ["Id", "Headline"]
    end
    
    it "uses the title attribute if passed in" do
      NewsStory.list_fields = [['id', title: "ID"], ['headline', title: "title"]]
      NewsStory.list_fields.map { |f| f[1][:title] }.should eq ["ID", "title"]
    end
    
    it "links the first column if no link is specified" do
      NewsStory.list_fields = [['id'], ['headline']]
      NewsStory.list_fields.select { |f| f[1][:link] == true }.map { |f| f[0] }.should eq ['id']
    end
    
    it "links the columns specified if any" do
      NewsStory.list_fields = [['id'], ['headline', link: true]]
      NewsStory.list_fields.select { |f| f[1][:link] == true }.map { |f| f[0] }.should eq ['headline']
    end
    
    it "adds a display_helper if one is not specified" do
      NewsStory.list_fields = [['id']]
      NewsStory.list_fields.first[1][:display_helper].should eq "display_id"
    end
    
    it "uses the display helper passed in if any" do
      NewsStory.list_fields = [['id', display_helper: "show_me_the_id"]]
      NewsStory.list_fields.first[1][:display_helper].should eq "show_me_the_id"
    end
  end
  
  describe "list_order" do
    it "returns what was passed in if anything" do
      NewsStory.list_order = "published_at"
      NewsStory.list_order.should eq "published_at"
    end
    
    it "has a default" do
      AdminResource::LIST_DEFAULTS[:list_order].should_not be_nil
    end
    
    it "returns the defined default if nothing set" do
      NewsStory.list_order = nil
      NewsStory.list_order.should eq AdminResource::LIST_DEFAULTS[:list_order]
    end
  end
  
  describe "list_per_page" do
    it "returns what was passed in if anything" do
      NewsStory.list_per_page = 5
      NewsStory.list_per_page.should eq 5
    end
    
    it "has a default" do
      AdminResource::LIST_DEFAULTS[:list_per_page].should_not be_nil
    end
    
    it "returns the defined default if nothing set" do
      NewsStory.send(:remove_instance_variable, :@list_per_page)
      NewsStory.list_per_page.should eq AdminResource::LIST_DEFAULTS[:list_per_page]
    end
    
    it "accepts `all` keyword" do
      NewsStory.list_per_page = "all"
      NewsStory.list_per_page.should eq nil
    end
    
    it "converts anything else to an integer" do
      NewsStory.list_per_page = "something"
      NewsStory.list_per_page.should eq 0
    end
  end
  
  describe "to_title" do
    it "returns the title-y attribute if the object responds to it" do
      news_story = create :news_story
      blog = create :blog
      blog_entry = create :blog_entry
      news_story.to_title.should eq news_story.short_headline
      blog.to_title.should eq blog.name
      blog_entry.to_title.should eq blog_entry.short_headline
    end
  end
end