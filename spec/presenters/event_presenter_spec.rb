require "spec_helper"

describe EventPresenter do
  describe "#description" do
    it "returns the body if the event is upcoming" do
      event = build :event, body: "Future", archive_description: "Past"
      event.stub(:upcoming?) { true }
      p = presenter(event)
      p.description.should match "Future"
    end
    
    it "returns the archive description if the event is in the past and it has an archive description" do
      event = build :event, body: "Future", archive_description: "Past"
      event.stub(:upcoming?) { false }
      p = presenter(event)
      p.description.should match "Past"
    end
    
    it "returns the body if the event is in the past and it does not have an archive description" do
      event = build :event, body: "Future", archive_description: nil
      event.stub(:upcoming?) { false }
      p = presenter(event)
      p.description.should match "Future"
    end
  end
  
  #-------------------

  describe "#sponsor" do
    it "returns nil if no sponsor is present" do
      event = build :event, sponsor: nil
      p = presenter(event)
      p.sponsor.should eq nil
    end
    
    it "contains a link if sponsor_link is present" do
      event = build :event, sponsor: "KPCC", sponsor_link: "scpr.org"
      p = presenter(event)
      p.sponsor.should match /a href/
      p.sponsor.should match /scpr\.org/
      p.sponsor.should match /KPCC/
    end
    
    it "returns the sponsor if no sponsor_link is present" do
      event = build :event, sponsor: "KPCC"
      p = presenter(event)
      p.sponsor.should_not match /a href/
      p.sponsor.should match /KPCC/
    end
  end
  
  #-------------------
  
  describe "#date" do
    it "returns range_date if event is upcoming" do
      event = build :event
      event.stub(:upcoming?) { true }
      p = presenter(event)
      p.should_receive(:range_date)
      p.date.should match /upcoming-date/
    end

    it "returns range_date if event is current" do
      event = build :event
      event.stub(:current?) { true }
      p = presenter(event)
      p.should_receive(:range_date)
      p.date.should match /upcoming-date/
    end
    
    it "returns a message plus the date if it was in the past" do
      event = build :event
      event.stub(:upcoming?) { false }
      event.stub(:current?) { false }
      p = presenter(event)
      p.should_receive(:range_date).twice
      p.date.should match /past-date/
      p.date.should match /This event took place on/
    end
  end
  
  #-------------------
  
  describe "#rsvp_link" do
    it "returns nil if rsvp_link is blank" do
      event = build :event, rsvp_link: nil
      p = presenter(event)
      event.rsvp_link.should eq nil
    end

    it "returns nil if event not upcoming" do
      event = build :event
      event.stub(:upcoming?) { false }
      p = presenter(event)
      p.rsvp_link.should eq nil
    end
    
    it "returns a link if rsvp_link is present and event is upcoming" do
      event = build :event, rsvp_link: "scpr.org"
      event.stub(:upcoming?) { true }
      p = presenter(event)
      p.rsvp_link.should match /a href/
      p.rsvp_link.should match /scpr\.org/
      p.rsvp_link.should match /RSVP/
    end
  end
  
  #-------------------
  
  describe "#location_name" do
    it "contains a link if location_link is present" do
      event = build :event, location_name: "Forum", location_link: "scpr.org/forum"
      p = presenter(event)
      p.location_name.should match /a href/
      p.location_name.should match /scpr\.org/
      p.location_name.should match /Forum/
    end
    
    it "returns the location name plain if location_link not present" do
      event = build :event, location_name: "Forum", location_link: nil
      p = presenter(event)
      p.location_name.should_not match /a href/
      p.location_name.should match /Forum/
    end
  end
  
  #-------------------
  
  describe "#address" do
    it "contains address_1 if it's present" do
      event = build :event, address_1: "123 Fake St."
      p = presenter(event)
      p.address.should eq "<li>123 Fake St.</li>"
    end
    
    it "contains address_2 if it's present" do
      event = build :event, address_2: "Apt. B"
      p = presenter(event)
      p.address.should eq "<li>Apt. B</li>"
    end
    
    it "contains city if it's present" do
      event = build :event, city: "Pasadena"
      p = presenter(event)
      p.address.should eq "<li>Pasadena</li>"
    end
    
    it "contains state if it's present" do
      event = build :event, state: "CA"
      p = presenter(event)
      p.address.should eq "<li>CA</li>"
    end
    
    it "contains zip_code if it's present" do
      event = build :event, zip_code: "92691"
      p = presenter(event)
      p.address.should eq "<li>92691</li>"
    end

    it "shows full address" do
      event = build :event, address_1: "123 Fake St.", address_2: "Apt. B", city: "Pasadena", state: "CA", zip_code: "92691"
      p = presenter(event)
      p.address.should eq "<li>123 Fake St.</li><li>Apt. B</li><li>Pasadena, CA 92691</li>"
    end
  end
  
  #-------------------
  
  describe "#map" do
    context "show_map true" do
      it "renders map if current? is true" do
        event = build :event, show_map: true
        event.stub(:current?) { true }
        event.stub(:upcoming?) { false }
        p = presenter(event)
        p.map.should match /google-maps/
      end
    
      it "renders map if upcoming? is true" do
        event = build :event, show_map: true
        event.stub(:current?) { false }
        event.stub(:upcoming?) { true }
        p = presenter(event)
        p.map.should match /google-maps/
      end
      
      it "doesn't render map if upcoming and current are false" do
        event = build :event, show_map: true
        event.stub(:current?) { false }
        event.stub(:upcoming?) { false }
        p = presenter(event)
        p.map.should eq nil
      end
    end
    
    context "show_map false" do
      it "doesn't render map" do
        event = build :event, show_map: false
        event.stub(:current?) { true }
        event.stub(:upcoming?) { true }
        p = presenter(event)
        p.map.should eq nil
      end
    end
  end
  
  #-------------------
  
  describe "#range_date" do
    # epoch = "Thursday, January 1, 12:00pm" 
    let(:epoch) { Chronic.parse("January 1, 1970") }
    
    context "is_all_day == true" do
      it "uses the start date only if there is no ends_at" do
        event = build :event, is_all_day: true, starts_at: epoch
        p = presenter(event)
        p.range_date.should eq "Thursday, January 1"
      end
    
      it "uses the start and end dates without times if ends_at is present" do
        event = build :event, is_all_day: true, starts_at: epoch, ends_at: epoch + 1.day
        p = presenter(event)
        p.range_date.should eq "Thursday, January 1 - Friday, January 2"
      end
    end
    
    context "ends_at blank" do
      it "uses the full starts_at time" do
        event = build :event, starts_at: epoch, ends_at: nil
        p = presenter(event)
        p.range_date.should eq "Thursday, January 1, 12pm"
      end
    end
    
    context "starts_at and ends_at same day" do
      it "consolidates the start and end date" do
        event = build :event, starts_at: epoch, ends_at: epoch + 1.hour
        p = presenter(event)
        p.range_date.should eq "Thursday, January 1, 12 - 1pm"
      end
      
      it "shows meridian for starts_at if it doesn't match that of ends_at" do
        event = build :event, starts_at: epoch - 2.hours, ends_at: epoch + 2.hours
        p = presenter(event)
        p.range_date.should eq "Thursday, January 1, 10am - 2pm"
      end
    end
    
    context "starts_at and ends_at different days" do
      it "Shows full dates for start and end dates" do
        event = build :event, starts_at: epoch, ends_at: epoch + 1.day
        p = presenter(event)
        p.range_date.should eq "Thursday, January 1, 12pm - Friday, January 2, 12pm"
      end
    end
    
    it "shows the minutes for both if the event does not start on the hour" do
      event = build :event, starts_at: epoch + 30.minutes, ends_at: epoch + 1.hour
      p = presenter(event)
      p.range_date.should eq "Thursday, January 1, 12:30 - 1:00pm"
    end
    
    it "shows the minutes for both if the event does not end on the hour" do
      event = build :event, starts_at: epoch, ends_at: epoch + 30.minutes
      p = presenter(event)
      p.range_date.should eq "Thursday, January 1, 12:00 - 12:30pm"
    end
    
    it "shows the minutes for both if the event does not start or end on the hour" do
      event = build :event, starts_at: epoch + 30.minutes, ends_at: epoch + 90.minutes
      p = presenter(event)
      p.range_date.should eq "Thursday, January 1, 12:30 - 1:30pm"
    end
  end
  
  #-------------------
  
  describe "#inline_address" do
    it "returns the full address if all address fields are present" do
      event = build :event, :with_address
      p = presenter(event)
      p.inline_address.should eq "123 Fake St., Apt. A, Pasadena, CA, 12345"
    end
    
    it "ignores fields that are not present" do
      event = build :event, :with_address, address_2: ""
      p = presenter(event)
      p.inline_address.should eq "123 Fake St., Pasadena, CA, 12345"
    end
  end
end
