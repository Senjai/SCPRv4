require 'spec_helper'

describe RecurringScheduleSlot do  
  describe "associations" do
    it { should belong_to(:program) }
  end
  
  #------------
  
  describe "validations" do
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }
    it { should validate_presence_of(:program) }
  end

  #------------
  
  describe "::on_at" do
    before :each do
      freeze_time_at(Chronic.parse("Monday"))
      t = Chronic.parse("Thursday 8am").second_of_week
      @slot = create :recurring_schedule_slot, start_time: t, end_time: t + 2.hours.to_i
    end
    
    it "gets the program on at the time passed in" do
      RecurringScheduleSlot.on_at(Chronic.parse("Thursday 8am")).should eq [@slot]
      RecurringScheduleSlot.on_at(Chronic.parse("Thursday 9am")).should eq [@slot]
      RecurringScheduleSlot.on_at(Chronic.parse("Thursday 9:59am")).should eq [@slot]
      RecurringScheduleSlot.on_at(Chronic.parse("Thursday 9:59:59am")).should eq [@slot]
    end
    
    it "is empty if nothing is found" do
      RecurringScheduleSlot.on_at(Chronic.parse("Thursday 10am")).should eq []
      RecurringScheduleSlot.on_at(Chronic.parse("Thursday 7:59:59am")).should eq []
      RecurringScheduleSlot.on_at(Chronic.parse("Sunday 9pm")).should eq []
    end
  end
  
  #------------
  
  describe "::as_time" do
    it "Adds the relative seconds to January 1, 2012 to get a Rails-y fake Time" do
      t = Chronic.parse("Thursday 8am").second_of_week
      slot = create :recurring_schedule_slot, start_time: t, end_time: t + 2.hours.to_i
      anchor = RecurringScheduleSlot::DATE_ANCHOR.to_i
      slot.class.as_time(slot.start_time).should eq Time.at(anchor + t)
      slot.class.as_time(slot.end_time).should eq Time.at(anchor + t+2.hours.to_i)
    end
  end
  
  #------------

  describe "#starts_at" do
    it "passes it off to ::as_time" do
      slot = create :recurring_schedule_slot
      RecurringScheduleSlot.should_receive(:as_time).with(slot.start_time)
      slot.starts_at
    end
  end

  #------------
  
  describe "#ends_at" do
    it "passes it off to ::as_time" do
      slot = create :recurring_schedule_slot
      RecurringScheduleSlot.should_receive(:as_time).with(slot.end_time)
      slot.ends_at
    end
  end
  
  #------------
  
  describe "#json" do
    it "is a thing, which does stuff" do
      slot = create :recurring_schedule_slot
      slot.to_json.should be_present
    end
  end


  #------------
  #------------
  
  describe "#show_modal?" do
    let(:schedule) { create :recurring_schedule_slot }
    
    it "returns false if program does not display_episodes" do
      program = build :kpcc_program, display_episodes: false
      schedule.program = program
      schedule.show_modal?.should be_false
    end

    it "returns true if program is display_episodes" do
      program = create(:kpcc_program, display_episodes: true)
      schedule.program = program
      schedule.show_modal?.should be_true
    end
  end
  
  describe "#format_time" do    
    it "returns noon if the time is noon" do
      schedule = build :recurring_schedule_slot, start_time: Chronic.parse("12pm").second_of_week
      schedule.format_time.should eq "noon"
    end
    
    it "returns midnight if the time is midnight" do
      schedule = build :recurring_schedule_slot, start_time: Chronic.parse("12am").second_of_week
      schedule.format_time.should eq "midnight"
    end
    
    it "returns minutes if it doesn't start on the top of the hour" do
      schedule = build :recurring_schedule_slot, start_time: Chronic.parse("12:30pm").second_of_week
      schedule.format_time.should match /\:30/
    end
    
    it "returns only the hour and am/pm if starts on the hour" do
      schedule = build :recurring_schedule_slot, start_time: Chronic.parse("1pm").second_of_week
      schedule.format_time.should_not match /\:00/
    end
  end
end
