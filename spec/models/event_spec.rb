require "spec_helper"

describe Event do  
  describe "associations" do
    it { should have_many :assets }
#    it { should belong_to :enco_audio }
    it { should have_many :uploaded_audio }
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
  
  describe "gmap_json" do
    it "makes an HTTP request to Google Map's API" do
      event = build :event, address_1: "123 Fake St.", address_2: "Apt. A", city: "Pasadena", state: "CA", zip_code: "12345"
      FakeWeb.register_uri(:get, /maps/, body: load_response_fixture_file("gmaps.json"))
      event.gmaps_json.should_not be_blank
    end
    
    it "returns nil if there is no address information" do
      event = build :event, address_1: "", address_2: "", city: "", state: "", zip_code: ""
      event.gmaps_json.should be_nil
    end
  end
  
  describe "lat_long" do
    it "returns nil if gmaps_json doesn't return anythiung" do
      event = build :event
      event.stub!(:gmaps_json) { nil }
      event.lat_long.should be_nil
    end
    
    it "returs nil if gmaps returns something besides an 'OK' status" do
      event = build :event
      event.stub!(:gmaps_json) { { status: "404" } }
      event.lat_long.should be_nil
    end
    
    it "returns the latitude and longitude if everything checks out" do
      event = build :event
      FakeWeb.register_uri(:get, /maps/, body: load_response_fixture_file("gmaps.json"))
      event.lat_long.should match /^-?\d+\.\d+,-?\d+\.\d+$/
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
  
  describe "closest" do
    it "returns the closest published future event" do
      events = create_list :event, 5
      closest = Event.closest
      closest.should eq Event.upcoming.first
      closest.should eq events.last
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
        spon_events = Event.forum
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