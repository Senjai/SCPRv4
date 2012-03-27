require "spec_helper"

describe Event do  
  describe "associations" do
    it { should have_many :assets }
  end
  
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
  
  describe "url_safe_address" do
    it "should not have spaces" do
      event = build :event
      event.url_safe_address.should_not match /\s/
    end
    
    it "should have plus-signs if there are spaces in the address" do
      event = build :event, address_1: "474 South Raymond"
      event.url_safe_address.should match /\+/
    end
  end
  
  describe "consoli_dated" do
    it "uses the start date only if is_all_day is true" do
      event = build :event, is_all_day: true, starts_at: 1.hour.from_now
      event.consoli_dated.should_not match event.starts_at.strftime("%l%P")
    end
    
    it "uses the full starts_at time if there is no ends_at" do
      event = build :event, starts_at: 1.hour.ago, ends_at: nil
      event.consoli_dated.should match event.starts_at.strftime("%l%P")
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
  end
  
  describe "upcoming?" do
    it "uses the start time if the event has no end time" do
      event = build :event, ends_at: nil, starts_at: 1.hour.ago
      event.upcoming?.should be_false
    end
    
    it "uses the end time if it exists" do
      event = build :event, starts_at: 1.hour.ago, ends_at: 1.hour.from_now
      event.upcoming?.should be_true
    end
  end
  
  describe "description" do
    it "returns the description if the event is upcoming" do
      event = build :event, description: "Future", archive_description: "Past"
      event.stub(:upcoming?) { true }
      event.description.should match "Future"
    end
    
    it "returns the archive description if the event is in the past and it has an archive description" do
      event = build :event, description: "Future", archive_description: "Past"
      event.stub(:upcoming?) { false }
      event.description.should match "Past"
    end
    
    it "returns the description if the event is in the past and it does not have an archive description" do
      event = build :event, description: "Future", archive_description: nil
      event.stub(:upcoming?) { false }
      event.description.should match "Future"
    end
  end
  
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
  
  describe "obj_key" do
    it "returns an object key" do
      event = create :event
      event.obj_key.should eq "events/event:#{event.id}"
    end
  end
  
  describe "closest" do # TODO All the scopes are ugly and inefficient
    it "returns the closest published future event" do
      events = create_list :event, 5
      closest = Event.closest
      closest.should eq Event.upcoming.first
      closest.should eq events.first
    end
  end
  
  describe "scopes" do
    describe "published" do
      it "only selects published content" do
        published = create :event, is_published: 1
        unpublished = create :event, is_published: 0
        published_events = Event.published
        published_events.count.should eq 1
        published_events.first.should eq published
      end
    end
    
    describe "upcoming" do
      it "only selects future events" do
        past_event = create :event, starts_at: 2.hours.ago, ends_at: 1.hour.ago
        future_event = create :event, starts_at: 2.hours.from_now, ends_at: 3.hours.from_now
        upcoming_events = Event.upcoming
        upcoming_events.count.should eq 1
        upcoming_events.first.should eq future_event
      end
    end
    
    describe "past" do
      it "only selects past events" do
        past_event = create :event, starts_at: 2.hours.ago, ends_at: 1.hour.ago
        future_event = create :event, starts_at: 2.hours.from_now, ends_at: 3.hours.from_now
        past_events = Event.past
        past_events.count.should eq 1
        past_events.first.should eq past_event
      end
    end
    
    describe "forum" do
      it "only selects events not of type 'spon' or 'pick'" do
        spon_event = create :event, etype: "spon" # "spon" = sponsored
        pick_event = create :event, etype: "pick"
        comm_event = create :event, etype: "comm"
        forum_events = Event.forum
        forum_events.count.should eq 1
        forum_events.first.should eq comm_event
      end
    end
    
    describe "sponsored" do
      it "only selects events of type 'spon'" do
        spon_event = create :event, etype: "spon"
        pick_event = create :event, etype: "pick"
        comm_event = create :event, etype: "comm"
        spon_events = Event.sponsored
        spon_events.count.should eq 1
        spon_events.first.should eq spon_event
      end
    end
  end
  
  describe "audio" do
    it "responds to audio" do
      build(:event).should respond_to :audio
    end
  end
  
  describe "asset" do
    it "can have an asset" do # TODO Stub the assethost requests
      event = create :event, asset_count: 1
      event.assets.first.asset.should be_present
    end
  end
  
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
  
  describe "#remote_link_path" do
    it "can generate a remote_link_path" do
      event = create :event
      event.remote_link_path.should_not be_nil
    end

    it "points to scpr.org" do
      event = create :event
      event.remote_link_path.should match "http://www.scpr.org"
    end
  end
end