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
    context "normal time slot" do
      before :each do
        freeze_time_at("Monday, October 22, 2012")
        t = Chronic.parse("Thursday 8am")
        @slot = create :recurring_schedule_slot, start_time: t.second_of_week, end_time: (t + 2.hours).second_of_week
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
    
    context "time slot bridges beginning of week threshold" do
      before :each do
        freeze_time_at("Monday, October 22, 2012")
        t = Chronic.parse("Saturday 11pm")
        @slot = create :recurring_schedule_slot, start_time: t.second_of_week, end_time: (t + 3.hours).second_of_week
      end
      
      it "gets the program on at the time passed in" do
        RecurringScheduleSlot.on_at(Chronic.parse("Saturday 11pm")).should eq [@slot]
        RecurringScheduleSlot.on_at(Chronic.parse("Sunday 12am")).should eq [@slot]
        RecurringScheduleSlot.on_at(Chronic.parse("Sunday 1am")).should eq [@slot]
        RecurringScheduleSlot.on_at(Chronic.parse("Sunday 1:59:59am")).should eq [@slot]
      end
      
      it "is empty if nothing is found" do
      end
    end
    
    context "daylight savings time" do
      before :each do
        # DST "Fall back" 2am -> 1am on November 4, 2012
        t = Time.new(2012, 11, 3, 23)
        @slot = create :recurring_schedule_slot, start_time: t.second_of_week, end_time: Time.new(2012, 11, 4, 3).second_of_week
      end
      
      it "selects stuff properly" do
        RecurringScheduleSlot.on_at(Time.new(2012, 11, 3, 23)).should eq [@slot]
        RecurringScheduleSlot.on_at(Time.new(2012, 11, 4, 0)).should eq [@slot]
        RecurringScheduleSlot.on_at(Time.new(2012, 11, 4, 1)).should eq [@slot]
        RecurringScheduleSlot.on_at(Time.new(2012, 11, 4, 2, 59, 59)).should eq [@slot]
        RecurringScheduleSlot.on_at(Time.new(2012, 11, 4, 3)).should eq []
      end
    end
  end

  #------------

  describe "::block" do
    context "same week" do
      it "returns the records within the block" do
        t = Time.new(2012, 10, 21, 8)
        slot0 = create :recurring_schedule_slot, start_time: (t-2.hours).second_of_week, end_time: t.second_of_week
        slot1 = create :recurring_schedule_slot, start_time: t.second_of_week, end_time: (t + 2.hours).second_of_week
        slot2 = create :recurring_schedule_slot, start_time: (t + 2.hours).second_of_week, end_time: (t + 4.hours).second_of_week
        slot3 = create :recurring_schedule_slot, start_time: (t + 4.hours).second_of_week, end_time: (t + 6.hours).second_of_week
        slot4 = create :recurring_schedule_slot, start_time: (t+6.hours).second_of_week, end_time: (t + 8.hours).second_of_week
        slot5 = create :recurring_schedule_slot, start_time: (t+8.hours).second_of_week, end_time: (t + 10.hours).second_of_week
        RecurringScheduleSlot.block(t, 8.hours).should eq [slot1, slot2, slot3, slot4]
      end
      
      it "returns partial slots" do
        t = Time.new(2012, 10, 21, 8)
        slot1 = create :recurring_schedule_slot, start_time: (t-1.hour).second_of_week, end_time: (t+1.hour).second_of_week
        slot2 = create :recurring_schedule_slot, start_time: (t+7.hours).second_of_week, end_time: (t+9.hours).second_of_week
        RecurringScheduleSlot.block(t, 8.hours).should eq [slot1, slot2]
      end
    end
    
    context "different week" do
      it "returns the records within the block" do
        t = Time.new(2012, 10, 20, 20)
        slot0 = create :recurring_schedule_slot, start_time: (t-2.hours).second_of_week, end_time: t.second_of_week
        slot1 = create :recurring_schedule_slot, start_time: t.second_of_week, end_time: (t + 2.hours).second_of_week
        slot2 = create :recurring_schedule_slot, start_time: (t + 2.hours).second_of_week, end_time: (t + 4.hours).second_of_week
        slot3 = create :recurring_schedule_slot, start_time: (t + 4.hours).second_of_week, end_time: (t + 6.hours).second_of_week
        slot4 = create :recurring_schedule_slot, start_time: (t+6.hours).second_of_week, end_time: (t + 8.hours).second_of_week
        slot5 = create :recurring_schedule_slot, start_time: (t+8.hours).second_of_week, end_time: (t + 10.hours).second_of_week
        RecurringScheduleSlot.block(t, 8.hours).should eq [slot1, slot2, slot3, slot4]
      end
      
      it "returns partial slots" do
        t = Time.new(2012, 10, 20, 20)
        slot1 = create :recurring_schedule_slot, start_time: (t-1.hour).second_of_week, end_time: (t+1.hour).second_of_week
        slot2 = create :recurring_schedule_slot, start_time: (t+7.hours).second_of_week, end_time: (t+9.hours).second_of_week
        RecurringScheduleSlot.block(t, 8.hours).should eq [slot1, slot2]
      end
    end
  end
  
  #------------
  
  describe "::as_time" do
    it "Adds the relative seconds to January 2, 2012 to get a Rails-y fake Time" do
      t      = Chronic.parse("Thursday 8am").second_of_week
      slot   = create :recurring_schedule_slot, start_time: t, end_time: t + 2.hours
      anchor = RecurringScheduleSlot::DATE_ANCHOR.to_i
      
      slot.class.as_time(slot.start_time).should eq Time.at(anchor + t)
      slot.class.as_time(slot.end_time).should eq Time.at(anchor + t + 2.hours)
    end
  end
  
  #------------

  describe "#starts_at" do
    context "slot is past" do
      it "returns the time with next week's date", focus: true do
        t = freeze_time_at Time.new(2012, 10, 30, 12, 0)
        slot = create :recurring_schedule_slot, start_time: (t-4.hours).second_of_week, end_time: (t-2.hours).second_of_week
        slot.starts_at.should eq Time.at(t.to_i+1.week-4.hours)
      end
    end
    
    context "slot is current" do
      it "returns the time with this week's date", focus: true do
        t = freeze_time_at Time.new(2012, 10, 30, 12, 0)
        slot = create :recurring_schedule_slot, start_time: (t-4.hours).second_of_week, end_time: (t-2.hours).second_of_week
        slot.starts_at.should eq Time.at(t.to_i-4.hours)
      end
    end
    
    context "slot is upcoming" do
      it "returns the time with this week's date", focus: true do
      end      
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

  describe "#day" do
  end

  #------------

  describe "#past?" do
  end
  
  #------------

  describe "#current?" do
  end
  
  #------------

  describe "#upcoming?" do
  end
  
  #------------

  describe "#day" do
  end
  
  #------------

  describe "#next" do
    it "selects the slot immediately following this one" do
      t = Time.new(2012, 10, 21, 12)
      slot1 = create :recurring_schedule_slot, start_time: t.second_of_week, end_time: (t + 2.hours).second_of_week
      slot2 = create :recurring_schedule_slot, start_time: (t + 2.hours).second_of_week, end_time: (t + 4.hours).second_of_week
      slot1.next.should eq slot2
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
