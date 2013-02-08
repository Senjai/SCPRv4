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
  end
  
  #------------------------
  
  describe "sphinx category searches" do
    before :each do
      category_news     = create :category, :is_news
      category_not_news = create :category, :is_not_news
      
      news     = [create(:news_story), create(:blog_entry), create(:show_segment), create(:content_shell)]
      not_news = [create(:news_story), create(:blog_entry), create(:show_segment), create(:content_shell)]
      
      news.each { |c| c.category = category_news; c.save! }
      not_news.each { |c| c.category = category_not_news; c.save! }
    end
    
    describe "#get_latest_news" do
      sphinx_spec(num: 0)
      
      it "only gets objects where category is news" do
        ts_retry(2) do
          news = helper.get_latest_news.to_a # to_a otherwise == comparison fails
          news.should_not be_blank
          news.select { |c| c.category.is_news == false }.should eq []
          news.select { |c| c.category.is_news == true }.should eq news
        end
      end
    end
  
    #------------------------
  
    describe "#get_latest_arts" do
      sphinx_spec(num: 0)
      
      it "only gets object where category is not news" do
        ts_retry(2) do
          arts = helper.get_latest_arts.to_a
          arts.should_not be_blank
          arts.select { |c| c.category.is_news == true }.should eq []
          arts.select { |c| c.category.is_news == false }.should eq arts
        end        
      end
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
    context "for object without bylines association" do
      it "returns KPCC if the object doesn't have bylines" do
        helper.render_byline(Object.new).should eq "KPCC"
      end
    end
    
    context "for object with bylines association" do
      let(:user) { create :bio, name: "Bryan" }
      
      before :each do
        @content = create :news_story

        primary   = create :byline, content: @content, role: ContentByline::ROLE_PRIMARY, user: user
        secondary = create :byline, content: @content, role: ContentByline::ROLE_SECONDARY, name: "Danny"

        @content.reload
      end
      
      it "turns the bylines with a user into links if links=true" do
        byline = helper.render_byline(@content)
        byline.should match /a href/
        byline.should match user.link_path
        byline.should match /Danny/
      end
    
      it "is does not use links if links=false" do
        byline = helper.render_byline(@content, false)
        byline.should_not match /a href/
        byline.should_not match user.link_path
        byline.should match /Bryan/
        byline.should match /Danny/
      end
    end
  end

  #------------------------

  describe "#render_contributing_byline" do
    let(:user) { create :bio, name: "Bryan" }
    let(:content) { create :news_story }
    
    it "returns contributing bylines as a sentence" do
      contributing1 = create :byline, content: content, role: ContentByline::ROLE_CONTRIBUTING, user: user
      contributing2 = create :byline, content: content, role: ContentByline::ROLE_CONTRIBUTING, name: "Danny"
      content.reload

      helper.render_contributing_byline(content, false).should match /Bryan and Danny/
    end
    
    it "returns a blank string if no contributing bylines are present" do
      primary = create :byline, content: content, role: ContentByline::ROLE_PRIMARY, user: user
      content.reload
      
      helper.render_contributing_byline(content, false).should eq ""
    end
    
  end
  
  #------------------------
  
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
    
    it "returns a `iso` format" do
      helper.format_date(@date, format: :iso).should match "1969-12-31"
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

  context "widgets" do
    let(:object) { create :blog_entry }
    
    describe "content_widget" do
      it "looks in /shared/cwidgets if just the name of the partial is given" do
        content_widget("social_tools", object).should match /Share this\:/
      end
    end
    
    #------------------------
    
    describe "#comment_count_for" do
      it "renders a link to the comments" do
        comment_count_for(object).should match "href"
        comment_count_for(object).should match object.link_path(anchor: "comments")
      end
      
      it "uses the class passed in and preserves the hard-coded classes" do
        comment_count = comment_count_for(object, class: "other")
        comment_count.should match /comment_link/
        comment_count.should match /social_disq/
        comment_count.should match /other/
      end
        
      it "doesn't render anything if content isn't present" do
        comment_count_for(nil).should be_nil
      end
      
      it "doesn't render anything if it doesn't respond to disqus_identifier" do
        comment_count_for(create :blog).should be_nil
      end
    end
    
    #------------------------

    describe "#comment_widget_for" do
      it "renders the comment_count partial" do
        comment_widget = comment_widget_for(object)
        comment_widget.should_not be_nil
        comment_widget.should match /comment-count/
      end
      
      it "has a link to the comments" do
        comment_widget_for(object).should match object.link_path(anchor: "comments")
      end
      
      it "doesn't render anything if object is not present" do
        comment_widget_for(nil).should be_nil
      end
      
      it "doesn't render anything if it doesn't respond to disqus_identifier" do
        comment_widget_for(create :blog).should be_nil
      end
      
      it "passes in the cssClass" do
        comment_widget_for(object, cssClass: "someclass").should match /someclass/
      end
    end
    
    #------------------------
    
    describe "#featured_comment" do
      pending
    end

    #------------------------
    
    describe '#twitter_profile_url' do
      it 'returns the full twitter url with the handle added' do
        url = helper.twitter_profile_url('kpcc')
        url.should match /twitter\.com/
        url.should match /kpcc$/
      end

      it 'parameterizes the handle' do
        helper.twitter_profile_url('@KPCC').should_not match /@/
      end
    end
    
    #------------------------

    describe "#comments_for" do
      it "renders the comments partial" do
        comments_for(object).should match 'comments'
      end
      
      it "passes along the cssClass" do
        comments_for(object, cssClass: "special_class").should match "special_class"
      end
    end
  end
end
