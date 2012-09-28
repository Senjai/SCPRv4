require "spec_helper"

describe Event do  
  describe "associations" do
    it_behaves_like "asset association"
    it_behaves_like "audio association"
  end

  #-------------------
  
  describe "validations" do
    it_behaves_like "slug validation"
    it_behaves_like "slug unique for date validation" do
      let(:scope) { :starts_at }
    end
    
    context "should validate" do
      before :each do
        Event.any_instance.stub(:should_validate?) { true }
      end
      
      it { should validate_presence_of(:etype) }
      it { should validate_presence_of(:starts_at) }
    end
    
    context "should not validate" do
      before :each do
        Event.any_instance.stub(:should_validate?) { false }
      end
      
      it { should_not validate_presence_of(:etype) }
      it { should_not validate_presence_of(:starts_at) }
    end
  end
  
  #-------------------
  
  describe "content base attributes" do
    it { should respond_to :headline }
    it { should respond_to :short_headline }
    it { should respond_to :body }
    it { should respond_to :teaser }
    it { should respond_to :link_path }
    it { should respond_to :remote_link_path }
    it { should respond_to :obj_key }
    it { should respond_to :auto_published_at }
    it { should respond_to :has_format? }
    it { should respond_to :disqus_identifier }
    it { should respond_to :disqus_shortname }
  end
  
  # ----------------

  describe "has_format?" do
    it "is true" do
      create(:event).has_format?.should be_false
    end
  end

  # ----------------
  
  describe "auto_published_at" do
    it "is true" do
      create(:event).auto_published_at.should be_false
    end
  end
  
  #-------------------
  
  describe "inline_address" do
    it "returns the full address if all address fields are present" do
      event = build :event, address_1: "123 Fake St.", address_2: "Apt. A", city: "Pasadena", state: "CA", zip_code: "12345"
      event.inline_address.should match "123 Fake St., Apt. A, Pasadena, CA, 12345"
    end
    
    it "ignores fields that are not present" do
      event = build :event, address_1: "123 Fake St.", address_2: "", city: "Pasadena", state: "CA", zip_code: "12345"
      event.inline_address.should match "123 Fake St., Pasadena, CA, 12345"
    end
    
    it "accepts an alternate separator" do
      event = build :event
      event.inline_address(" | ").should match " | "
    end
  end
  
  #-------------------
  
  describe "Event.sorted" do
    before :each do
      freeze_time_at "noon"
    end
    
    # Is there a more reliable way to test this?
    it "sorts based on instance sorter" do
      past_one      = build :event, starts_at: 2.hours.ago,      ends_at: 1.hour.ago
      past_many     = build :event, starts_at: 3.days.ago,       ends_at: 1.day.ago
      current_one   = build :event, starts_at: 1.hour.ago,       ends_at: 1.hour.from_now
      current_many  = build :event, starts_at: 1.day.ago,        ends_at: 1.day.from_now
      future_one    = build :event, starts_at: 1.hour.from_now,  ends_at: 2.hours.from_now
      future_many   = build :event, starts_at: 2.days.from_now,  ends_at: 4.days.from_now
      
      events = [past_one, past_many, current_one, current_many, future_one, future_many].shuffle
      Event.sorted(events).should eq [past_many, past_one, current_one, future_one, current_many, future_many]
    end
  end
  
  #-------------------
  
  describe "sorter" do
    before :each do
      freeze_time_at "noon"
    end
    
    it "returns the event's ends_at if it's multiple days and current" do
      event = build :event, :multiple_days_current
      event.sorter.should eq event.ends_at
    end
    
    it "returns the event's starts_at if it's < 24 hours" do
      event = build :event, :current
      event.sorter.should eq event.starts_at
    end
    
    it "returns the event's starts_at if it's multiple days in the future" do
      event = build :event, :multiple_days_future
      event.sorter.should eq event.starts_at
    end
    
    it "returns the event's starts_at if it's multiple days in the past" do
      event = build :event, :multiple_days_past
      event.sorter.should eq event.starts_at
    end
  end
  
  #-------------------

  describe "multiple_days?" do
    it "is true if > 24 hours" do
      event = Event.new
      event.stub(:minutes) { 60*48 }
      event.multiple_days?.should be_true
    end
    
    it "is false if < 24 hours" do
      event = Event.new
      event.stub(:minutes) { 60*12 }
      event.multiple_days?.should be_false
    end
    
    it "is false if == 24 hours" do
      event = Event.new
      event.stub(:minutes) { 60*24 }
      event.multiple_days?.should be_false
    end
  end
  
  #-------------------

  describe "minutes" do
    it "calculates the minutes of the event" do
      event = build :event, starts_at: 2.minutes.ago, ends_at: 3.minutes.from_now
      event.minutes.should be_a Fixnum
      event.minutes.should eq 5
    end
  end
  
  #-------------------

  describe "ongoing?" do
    it "is true if multiple day and current" do
      event = Event.new
      event.stub(:multiple_days?) { true }
      event.stub(:current?) { true }
      event.ongoing?.should be_true
    end
  end
  
  #-------------------
  
  describe "consoli_dated" do
    it "uses the start date only if is_all_day is true" do
      event = build :event, is_all_day: true, starts_at: 1.hour.from_now
      event.consoli_dated.should_not match event.starts_at.strftime("%l%P")
    end
    
    it "uses the full starts_at time if there is no ends_at" do
      event = build :event, starts_at: Chronic.parse("5pm"), ends_at: nil
      event.consoli_dated.should match "5pm"
    end
    
    it "consolidates the start and end date if they are the same" do
      event = build :event, starts_at: 2.hours.ago, ends_at: 1.hour.ago
      event.consoli_dated.scan(event.starts_at.strftime("%A")).length.should eq 1
    end
    
    it "Shows full dates for start and end dates if they are different days" do
      event = build :event, starts_at: Time.now.yesterday, ends_at: Time.now.tomorrow
      event.consoli_dated.should match event.starts_at.strftime("%A")
      event.consoli_dated.should match event.ends_at.strftime("%A")
    end
    
    it "shows meridian for starts_at if it doesn't match that of ends_at" do
      event = build :event, starts_at: Time.now.beginning_of_day, ends_at: Time.now.end_of_day
      event.consoli_dated.should match "am"
      event.consoli_dated.should match "pm"
    end
    
    it "hides meridian for starts_at only if it matches that of ends_at" do
      event = build :event, starts_at: Time.now.beginning_of_day, ends_at: Time.now.beginning_of_day + 60*60*2
      event.consoli_dated.scan("am").length.should eq 1
    end
    
    it "only shows the hour if the event starts and ends on the hour" do
      event = build :event, starts_at: Chronic.parse("5pm"), ends_at: Chronic.parse("6pm")
      event.consoli_dated.should_not match /:/
    end
    
    it "shows the minutes for both if the event does not start on the hour" do
      event = build :event, starts_at: Chronic.parse("5:30pm"), ends_at: Chronic.parse("6pm")
      event.consoli_dated.scan(/:/).length.should eq 2
    end
    
    it "shows the minutes for both if the event does not end on the hour" do
      event = build :event, starts_at: Chronic.parse("5pm"), ends_at: Chronic.parse("5:30pm")
      event.consoli_dated.scan(/:/).length.should eq 2
    end
    
    it "shows the minutes for both if the event does not start or end on the hour" do
      event = build :event, starts_at: Chronic.parse("5:30pm"), ends_at: Chronic.parse("6:30pm")
      event.consoli_dated.scan(/:/).length.should eq 2
    end
  end
  
  #-------------------
  
  describe "upcoming?" do
    it "is true if the start time is greater than right now" do
      event = build :event, ends_at: nil, starts_at: Chronic.parse("1 hour from now")
      event.upcoming?.should be_true
    end
    
    it "is false if the event start time is in the past" do
      event = build :event, ends_at: nil, starts_at: Chronic.parse("1 hour ago")
      event.upcoming?.should be_false
    end
  end
  
  #-------------------
  
  describe "current?" do
    before :each do
      freeze_time_at "noon"
    end
    
    it "is true if Time.now is between the start and end times" do
      event = build :event, :current
      event.current?.should be_true
    end
    
    it "is true if ends_at is blank and Time.now is between start time and end of day" do
      event = build :event, starts_at: Chronic.parse("1 hour ago"), ends_at: nil
      event.current?.should be_true
    end
    
    it "is false if start time is in the future" do
      event = build :event, :future
      event.current?.should be_false
    end
    
    it "is false if event ends_at is in the past" do
      event = build :event, :past
      event.current?.should be_false
    end
    
    it "is false if no ends_at and event starts_at was yeserday" do
      event = build :event, starts_at: Time.now.yesterday
      event.current?.should be_false
    end
  end

  #-------------------

  describe "description" do
    it "returns the body if the event is upcoming" do
      event = build :event, body: "Future", archive_description: "Past"
      event.stub(:upcoming?) { true }
      event.description.should match "Future"
    end
    
    it "returns the archive description if the event is in the past and it has an archive description" do
      event = build :event, body: "Future", archive_description: "Past"
      event.stub(:upcoming?) { false }
      event.description.should match "Past"
    end
    
    it "returns the body if the event is in the past and it does not have an archive description" do
      event = build :event, body: "Future", archive_description: nil
      event.stub(:upcoming?) { false }
      event.description.should match "Future"
    end
  end

  #-------------------
  
  describe "audio_url" do
    it "has the SCPR media url" do
      event = build :event
      event.audio_url.should match "media.scpr.org"
    end
    
    it "has the audio file in it" do
      event = build :event, audio: "/some/path/audio.mp3"
      event.audio_url.should match event.audio
    end
  end

  #-------------------
  
  describe "#link_path" do
    it "can generate a link_path" do
      event = create :event
      event.link_path.should_not be_nil
    end
  
    it "accepts an options hash" do
      event = create :event
      event.link_path(anchor: "comments").should_not be_blank
    end
  
    it "merges in an options hash" do
      event = create :event
      event.link_path(anchor: "comments").should match "#comments"
    end
    
    it "does not override the hard-coded options" do
      entry = create :event
      entry.link_path(slug: "wrong").should_not match "wrong"
    end
  end

  #-------------------
  
  describe "closest" do # TODO All the scopes are ugly and inefficient
    it "returns the closest published future event" do
      events = create_list :event, 5
      closest = Event.closest
      closest.should eq Event.upcoming.first
      closest.should eq events.first
    end
  end

  #-------------------
  
  describe "scopes" do
    describe "published" do
      it "only selects published content" do
        published = create :event, is_published: 1
        unpublished = create :event, is_published: 0
        Event.published.should eq [published]
      end
    end
    
    describe "upcoming" do
      it "only selects future events" do
        past_event = create :event, starts_at: 2.hours.ago, ends_at: 1.hour.ago
        future_event = create :event, starts_at: 2.hours.from_now, ends_at: 3.hours.from_now
        Event.upcoming.should eq [future_event]
      end
    end
    
    describe "upcoming_and_current" do
      it "selects event that are future or currently happening" do
        past_event = create :event, starts_at: 2.hours.ago, ends_at: 1.hour.ago
        current_event = create :event, starts_at: 2.hours.ago, ends_at: 2.hours.from_now
        future_event = create :event, starts_at: 2.hours.from_now, ends_at: 3.hours.from_now
        Event.upcoming_and_current.should eq [current_event, future_event]
      end
      
      it "orders by starts_at" do
        Event.upcoming_and_current.to_sql.should match /order by starts_at/i
      end
    end
    
    describe "past" do
      it "only selects past events" do
        past_event = create :event, starts_at: 2.hours.ago, ends_at: 1.hour.ago
        future_event = create :event, starts_at: 2.hours.from_now, ends_at: 3.hours.from_now
        Event.past.should eq [past_event]
      end
      
      it "does not include current events" do
        past_event = create :event, starts_at: 3.hours.ago, ends_at: 2.hours.ago
        current_event = create :event, starts_at: 1.hours.ago, ends_at: 3.hours.from_now
        Event.past.should eq [past_event]
      end
    end
    
    describe "forum" do
      it "only selects events of types in ForumTypes array" do
        spon_event = create :event, etype: "spon" # "spon" = sponsored
        pick_event = create :event, etype: "pick"
        comm_event = create :event, etype: "comm"
        forum_events = Event.forum
        forum_events.should eq [comm_event]
      end
    end
    
    describe "sponsored" do
      it "only selects events of type 'spon'" do
        spon_event = create :event, etype: "spon"
        pick_event = create :event, etype: "pick"
        comm_event = create :event, etype: "comm"
        spon_events = Event.sponsored
        spon_events.should eq [spon_event]
      end
    end
  end

  #-------------------
  
  describe "is_forum_event" do
    it "is true if event type in the ForumTypes variable" do
      Event::ForumTypes.each do |etype|
        event = build :event, etype: etype
        event.is_forum_event?.should be_true
      end
    end
    
    it "is false if event is something else" do
      event = build :event, etype: "spon"
      event.is_forum_event?.should be_false
    end
  end
end
