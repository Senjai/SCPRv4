require 'spec_helper'

describe ApplicationHelper do  
  describe "#any_to_list?" do
    it "returns the block if there are records" do
      records = (1..5)
      any_to_list?(records) { "Records list" }.should eq "Records list"
    end
    
    it "returns a default message if there are no records and no message is specified" do
      records = []
      any_to_list?(records) { "Records list" }.should eq "<span class='none-to-list'>There are currently no Arrays</span>".html_safe # fascinating list of arrays
    end
    
    it "returns a specified message if there are no records" do
      records = []
      any_to_list?(records, message: "None!") { "Records list" }.should eq "None!"
    end
    
    it "returns true if there are records and no block is given" do
      records = (1..5)
      any_to_list?(records).should be_true
    end
    
    it "returns false if there are no records and no block is given" do
      records = []
      any_to_list?(records).should be_false
    end
  end
  
  ## get_latest_arts and get_latest_news are very slow because they are making actual API calls... This should be fixed
  describe "#get_latest_arts" do
    before :each do
      make_content
      ThinkingSphinx::Test.start
      sleep(0.25)
      @arts = get_latest_arts
    end
    
    after :each do
      ThinkingSphinx::Test.stop
    end
      
    it "returns 12 items" do
      @arts.count.should eq 12
    end
    
    it "is ordered by published_at desc" do
      # FIXME: This doesn't always work for some reason. Check database cleaning strategy. 
      # @arts[0].published_at.should be > @arts[1].published_at
      # @arts[10].published_at.should be < @arts[9].published_at
    end
    
    it "doesn't return any records where category_is_news" do
      @arts.any? { |r| r.category.is_news }.should be_false
    end
    
    it "only returns records with a category assigned" do
      @arts.any? { |r| r.category.blank? }.should be_false
    end
  end
  
  describe "#get_latest_news" do
    before :each do
      make_content
      ThinkingSphinx::Test.start
      @news = get_latest_news
    end
    
    after :each do
      ThinkingSphinx::Test.stop
    end
      
    it "returns 12 items" do
      @news.count.should eq 12
    end
    
    it "is ordered by published_at desc" do
      # FIXME: This doesn't always work for some reason. Check database cleaning strategy.
      # @news[0].published_at.should be > @news[1].published_at
      @news[10].published_at.should be < @news[9].published_at
    end
    
    it "only returns records where category_is_news" do
      @news.any? { |r| !r.category.is_news }.should be_false
    end
  end
  
  describe "#render_byline" do
    pending # TODO: Write tests for this
  end
  
  describe "#page_title" do
    it "accepts and array and joins them by the default separator" do
      page_title([1, 2]).should eq "1 | 2"
    end
    
    it "accepts and uses a different separator" do
      page_title([1, 2], " - ").should eq "1 - 2"
    end
    
    it "Return the first argument as a string if it is not an array" do
      page_title("Page").should eq "Page"
    end
  end  
  
  describe "#smart_date_js" do # These tests could be dryed up
    it "returns a time tag with all attributes filled in if some sort of Timestamp object is passed in" do
      [Time, DateTime].each do |datetime|
        time = datetime.now
        time.should respond_to(:strftime)
        smart_date_js(time).should eq content_tag(:time, '', class: "smart smarttime", "datetime" => time.strftime("%FT%R"), "data-unixtime" => time.to_i)
      end
    end
    
    it "returns a time tag with all attributes filled in if some sort of content is passed in" do
      content = create :video_shell # arbitrary object which will respond to published_at
      content.should respond_to(:published_at)
      smart_date_js(content).should eq content_tag(:time, '', class: "smart smarttime", "datetime" => content.published_at.strftime("%FT%R"), "data-unixtime" => content.published_at.to_i)
    end
    
    it "returns nil if passed-in object can't respond to published_at or strftime" do
      smart_date_js("invalid").should eq nil
    end
    
    it "accepts an optional options hash and merges it into the options for the content_tag" do
      time = Time.now
      smart_date_js(time, "data-window" => "8h").match("data-window").should_not be_nil
    end
    
    it "overrides the default options in the content_tag with any passed-in options" do
      time = Time.now
      smart_date_js(time, "datetime" => "new format").match("datetime=\"new format\"").should_not be_nil
    end
    
    it "merges a passed-in class with the required smarttime class" do
      time = Time.now
      smart_date_js(time, class: "newClass").match("newClass smart smarttime").should_not be_nil
    end
  end

end
