require 'spec_helper'

describe ApplicationHelper do
  describe "#any_to_list?" do
    it "returns the block if there are records" do
      helper.any_to_list?(1..5) { "Records list" }.should match "Records list"
    end
    
    it "returns a default message if there are no records and no message is specified" do
      helper.any_to_list?([]) { "Records list" }.should match "There is nothing here to list."
    end
    
    it "returns a specified message if there are no records" do
      helper.any_to_list?([], message: "None!") { "Records list" }.should match "None!"
    end
    
    it "returns a special message if: no records, no message, title is specified" do
      helper.any_to_list?([], title: "Events") { "Records list" }.should match "Events"
    end
    
    it "returns true if there are records and no block is given" do
      helper.any_to_list?(1..5).should be_true
    end
    
    it "returns false if there are no records and no block is given" do
      helper.any_to_list?([]).should be_false
    end
    
    it "uses a span wrapper by default" do
      helper.any_to_list?([]) { "Records List" }.should match "span"
    end
    
    it "uses a span wrapper if wrapper is true" do
      helper.any_to_list?([], wrapper: true) { "Records List" }.should match "span"
    end
        
    it "uses the wrapper passed in" do
      helper.any_to_list?([], wrapper: :div) { "Records List" }.should match "div"
    end
    
    it "does not use a wrapper if wrapper is false" do
      helper.any_to_list?([], wrapper: false, message: "No") { "Records List" }.should eq "No"
    end
  end
  
  #------------------------

  describe "retry stale for sphinx" do
    before :all do
      setup_sphinx
    end

    after :all do
      teardown_sphinx
    end

    it "doesn't return a nil value" do
      make_content(1)
      index_sphinx
      ContentShell.all.first.destroy
      ContentShell.count.should eq 0
      arts = ThinkingSphinx::Test.run { get_latest_arts }
      arts.should_not include nil
    end
  end
  
  #------------------------
  
  describe "get latest using sphinx" do
    before :all do
      setup_sphinx
    end
    
    before :each do
      stub_publishing_callbacks
      make_content(7)
      index_sphinx
      
      ThinkingSphinx::Test.run do
        @arts = get_latest_arts
        @news = get_latest_news
      end
    end
    
    after :all do
      teardown_sphinx
    end
    
    it "all returns an array" do
      @arts.should be_a Array
      @news.should be_a Array
    end
  
    it "all returns 12 items" do
      @arts.count.should eq 12
      @news.count.should eq 12
    end

    it "all is ordered by published_at desc" do
      @arts[0].published_at.should be > @arts[1].published_at
      @arts[10].published_at.should be < @arts[9].published_at
      @news[0].published_at.should be > @news[1].published_at
      @news[10].published_at.should be < @news[9].published_at
    end
    
    it "arts doesn't return any records where category_is_news" do
      @arts.any? { |r| r.category.try(:is_news) == true }.should be_false # TODO Figure out why it's returning records without a category sometimes.
    end

    it "arts does not return ShowEpisodes" do
      @arts.any? { |r| r.is_a? ShowEpisode }.should be_false
    end
    
    it "news only returns records where category_is_news" do
      @news.any? { |r| r.category.try(:is_news) == false }.should be_false # TODO Figure out why it's returning records without a category sometimes.
    end
  end
  
  #------------------------
  
  describe "render_asset" do
    it "should render a fallback image if there are no assets and fallback is true" do
      content = build :content_shell
      content.stub(:assets) { [] }
      helper.render_asset(content, "thumb", true).should match "fallback"
    end
    
    it "should move on to render_asset if there are assets" do
      content = build :content_shell
      content.stub(:assets) { [1, 2, 3] }
      view.stub(:render) { "asset rendered" }
      helper.render_asset(content, "thumb", true).should match "asset rendered"
    end
    
    it "should return a blank string if object does not have assets method" do
      helper.render_asset("string", "thumb").should eq ''
    end
    
    it "should return a blank string if object does not have assets and no fallback is requested" do
      content = create :content_shell
      helper.render_asset(content, "thumb", false).should eq ''
    end
  end
  
  #------------------------
  
  describe "#render_byline" do
    pending "needs tests"
  end
  
  describe "#page_title" do
    it "accepts and array and joins them by the default separator" do
      helper.page_title([1, 2]).should eq "1 | 2"
    end
    
    it "accepts and uses a different separator" do
      helper.page_title([1, 2], " - ").should eq "1 - 2"
    end
    
    it "Return the first argument as a string if it is not an array" do
      helper.page_title("Page").should eq "Page"
    end
    
    it "returns @PAGE_TITLE if it exists" do
      @PAGE_TITLE = "some title"
      helper.page_title("anything else").should eq "some title"
    end
  end  
  
  #------------------------
  
  describe "#smart_date_js" do # These tests could be dryed up
    it "returns a time tag with all attributes filled in if some sort of Timestamp object is passed in" do
      [Time, DateTime].each do |datetime|
        time = datetime.now
        time.should respond_to(:strftime)
        helper.smart_date_js(time).should eq content_tag(:time, '', class: "smart smarttime", "datetime" => time.strftime("%FT%R"), "data-unixtime" => time.to_i)
      end
    end
    
    it "returns a time tag with all attributes filled in if some sort of content is passed in" do
      content = create :video_shell # arbitrary object which will respond to published_at
      content.should respond_to(:published_at)
      helper.smart_date_js(content).should eq helper.content_tag(:time, '', class: "smart smarttime", "datetime" => content.published_at.strftime("%FT%R"), "data-unixtime" => content.published_at.to_i)
    end
    
    it "returns nil if passed-in object can't respond to published_at or strftime" do
      helper.smart_date_js("invalid").should eq nil
    end
    
    it "accepts an optional options hash and merges it into the options for the content_tag" do
      time = Time.now
      helper.smart_date_js(time, "data-window" => "8h").should match "data-window"
    end
    
    it "overrides the default options in the content_tag with any passed-in options" do
      time = Time.now
      helper.smart_date_js(time, "datetime" => "new format").should match "datetime=\"new format\""
    end
    
    it "merges a passed-in class with the required smarttime class" do
      time = Time.now
      helper.smart_date_js(time, class: "newClass").should match "newClass smart smarttime"
    end
  end
  
  #------------------------
  
  describe "#format_date" do
    before :each do
      @date = Time.at(0) # 1969-12-31 16:00:00 -0800
    end
    
    it "returns a `numbers` format" do
      helper.format_date(@date, format: :numbers).should match "12-31-69"
    end
    
    it "returns a `full-date` format" do
      helper.format_date(@date, format: :full_date).should match "December 31st, 1969"
    end
    
    it "returns a 'event' format" do
      helper.format_date(@date, format: :event).should match "Wednesday, December 31"
    end
    
    it "accepts a custom format" do
      helper.format_date(@date, with: "%D").should match "12/31/69"
    end
    
    it "prefers the custom format if a premade format is also specified" do
      helper.format_date(@date, with: "%D", format: :event).should match "12/31/69"
    end
    
    it "includes the time if specified" do
      helper.format_date(@date, format: :event, time: true).should match "4:00pm"
    end
  end
  
  #------------------------
  
  describe "modal" do
    it "renders the modal shell partial" do
      helper.modal("anything") { "content" }.should_not be_blank
    end
    
    it "raises an error if no style is passed in" do
      expect { helper.modal() { "content" } }.to raise_error ArgumentError
    end
    
    it "raises an error if a block is not given" do
      expect { helper.modal("anything") }.to raise_error
    end
    
    it "passes in the style" do
      helper.modal("awesome-modal") { "content" }.should match /awesome\-modal/
    end
    
    it "makes content_for :modal_content" do
      helper.modal("anything") { "Hello!" }
      helper.content_for?(:modal_content).should be_true
    end
    
    it "renders the modal_content block" do
      helper.modal("anything") { "Hello!" }.should match /Hello!/
    end
  end
  
  #------------------------
  
  describe "split_collection" do
    it "returns an array" do
      helper.split_collection([], 5).should be_a Array
    end
    
    it "sets the first slice to the first `num` elements" do
      arr = (1..10).to_a
      helper.split_collection(arr, 5)[0].should eq (1..5).to_a
    end
    
    it "sets the last slice to the rest of the array" do
      arr = (1..10).to_a
      helper.split_collection(arr, 5)[1].should eq (6..10).to_a
    end
    
    it "returns an empty array for the last portion if collection is smaller `num`" do
      arr = (1..5).to_a
      split = helper.split_collection(arr, 10)
      split[0].should eq (1..5).to_a
      split[1].should eq []
    end
  end
  
  #------------------------
  
  describe "watch_gmaps" do
    it "adds the google maps API script reference to the header" do
      helper.watch_gmaps
      helper.content_for(:headerjs).should match /script/
    end
    
    it "finds the google maps API key and uses that in the API script reference" do
      helper.watch_gmaps
      helper.content_for(:headerjs).should match API_KEYS["google"]["maps"]
    end
    
    it "adds a GMapsLoader object to the footer js" do
      helper.watch_gmaps
      helper.content_for(:footerjss).should match /GMapsLoader/
    end
    
    it "takes options to pass into the GMaps Loader object" do
      helper.watch_gmaps(zoom: 0)
      helper.content_for(:footerjss).should match "\"zoom\":0"
    end
  end

end
