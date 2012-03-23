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
  
  describe "get latest using sphinx" do
    describe "#get_latest_arts" do
      before :all do
        puts "Starting Sphinx and indexing..."
        DatabaseCleaner.strategy = :truncation
        make_content(7)
        ThinkingSphinx::Test.start
        ThinkingSphinx::Test.index
        @arts = get_latest_arts
      end
      
      after :all do
        ThinkingSphinx::Test.stop
        DatabaseCleaner.strategy = :transaction
      end
      
      it "returns 12 items" do
        @arts.count.should eq 12
      end
    
      it "is ordered by published_at desc" do
        @arts[0].published_at.should be > @arts[1].published_at
        @arts[10].published_at.should be < @arts[9].published_at
      end
    
      it "doesn't return any records where category_is_news" do
        @arts.any? { |r| r.category.try(:is_news) == true }.should be_false # TODO Figure out why it's returning records without a category sometimes.
      end
    
      it "does not return ShowEpisodes" do
        @arts.any? { |r| r.is_a? ShowEpisode }.should be_false
      end
    end
  
    describe "#get_latest_news" do
       before :all do
         puts "Starting Sphinx and indexing..."
         DatabaseCleaner.strategy = :truncation
         make_content(7)
         ThinkingSphinx::Test.start
         ThinkingSphinx::Test.index
         @news = get_latest_news
       end
       
       after :all do
         ThinkingSphinx::Test.stop
         DatabaseCleaner.strategy = :transaction
       end
       
      it "returns 12 items" do
        @news.count.should eq 12
      end
    
      it "is ordered by published_at desc" do
        @news[0].published_at.should be > @news[1].published_at
        @news[10].published_at.should be < @news[9].published_at
      end
    
      it "only returns records where category_is_news" do
        @news.any? { |r| r.category.try(:is_news) == false }.should be_false # TODO Figure out why it's returning records without a category sometimes.
      end
    end
  end
  
  describe "#render_byline" do
    pending "needs tests"
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
  
  describe "#event_link" do
    let(:event) { build :event, starts_at: Time.at(0) } # December 31, 1969
    
    it "returns nil if the object doesn't respond to starts_at" do
      event_link("string").should be_nil
    end
    
    it "returns the 'event' format" do
      event_link(event).should match "Wednesday, December 31"
    end
    
    it "uses the event's link_path as the link if an event is provided" do
      event_link(event).should match event.link_path
    end
    
    it "takes options" do
      event_link(event, class: "some-class").should match /some-class/
    end
    
    it "returns a link" do
      event_link(event).should match /<a /
    end
  end
  
  describe "#format_date" do
    before :each do
      @date = Time.at(0) # December 31, 1969
    end
    
    it "returns a `numbers` format" do
      format_date(@date, format: :numbers).should match "12-31-69"
    end
    
    it "returns a `full-date` format" do
      format_date(@date, format: :full_date).should match "December 31st, 1969"
    end
    
    it "returns a 'event' format" do
      format_date(@date, format: :event).should match "Wednesday, December 31"
    end
    
    it "accepts a custom format" do
      format_date(@date, with: "%D").should match "12/31/69"
    end
  end
  
  describe "modal" do
    pending
  end

end
