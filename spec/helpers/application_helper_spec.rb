require 'spec_helper'

describe ApplicationHelper do  
  describe "#any_to_list?" do
    it "returns the block if there are records" do
      any_to_list?(1..5) { "Records list" }.should match "Records list"
    end
    
    it "returns a default message if there are no records and no message is specified" do
      any_to_list?([]) { "Records list" }.should match "There is nothing here to list."
    end
    
    it "returns a specified message if there are no records" do
      any_to_list?([], message: "None!") { "Records list" }.should match "None!"
    end
    
    it "returns a special message if: no records, no message, title is specified" do
      any_to_list?([], title: "Events") { "Records list" }.should match "Events"
    end
    
    it "returns true if there are records and no block is given" do
      any_to_list?(1..5).should be_true
    end
    
    it "returns false if there are no records and no block is given" do
      any_to_list?([]).should be_false
    end
    
    it "uses a span wrapper by default" do
      any_to_list?([]) { "Records List" }.should match "span"
    end
    
    it "uses a span wrapper if wrapper is true" do
      any_to_list?([], wrapper: true) { "Records List" }.should match "span"
    end
        
    it "uses the wrapper passed in" do
      any_to_list?([], wrapper: :div) { "Records List" }.should match "div"
    end
    
    it "does not use a wrapper if wrapper is false" do
      any_to_list?([], wrapper: false, message: "No") { "Records List" }.should eq "No"
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
      smart_date_js(time, "data-window" => "8h").should match "data-window"
    end
    
    it "overrides the default options in the content_tag with any passed-in options" do
      time = Time.now
      smart_date_js(time, "datetime" => "new format").should match "datetime=\"new format\""
    end
    
    it "merges a passed-in class with the required smarttime class" do
      time = Time.now
      smart_date_js(time, class: "newClass").should match "newClass smart smarttime"
    end
  end
  
  describe "#calendar_link" do
    before :each do
      @date = Time.at(0) # Wednesday, December 31, 1969
    end
    
    it "returns nil if the object doesn't respond to strftime" do
      calendar_link("string").should be_nil
    end
    
    it "returns the default if a format isn't specified" do
      calendar_link(@date).should match "Dec 31, 1969"
    end
    
    it "returns a `numbers` format" do
      calendar_link(@date, format: :numbers).should match "12-31-69"
    end
    
    it "returns a `full-date` format" do
      calendar_link(@date, format: :full_date).should match "December 31st, 1969"
    end
    
    it "returns a 'full-day' format" do
      calendar_link(@date, format: :full_day).should match "Wednesday, December 31"
    end
    
    it "accepts a custom format" do
      calendar_link(@date, format: :custom, with: "%D").should match "12/31/69"
    end
    
    it "uses the event's link_path as the link if an event is provided" do
      event = create :event
      calendar_link(@date, event: event).should match event.link_path
    end
    
    it "uses the events_path if no event is provided" do
      calendar_link(@date).should match events_path
    end
    
    it "returns a link if no wrapper is specified" do
      calendar_link(@date).should match /<a /
    end
    
    it "uses the requests wrapper if it is a span, div, or p" do
      calendar_link(@date, wrapper: "p").should match /<p /
      calendar_link(@date, wrapper: "div").should match /<div /
      calendar_link(@date, wrapper: "span").should match /<span /
    end
    
    it "doesn't allow any other tags" do
      calendar_link(@date, wrapper: "b").should_not match /<b/
    end
  end

end
