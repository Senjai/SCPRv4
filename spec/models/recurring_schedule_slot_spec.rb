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
  
  describe "::as_time" do
    context "same timezone" do
      it "returns the time from the beginning of the week" do
        t       = freeze_time_at Time.new(2012, 10, 20, 12, 0, 0) # Saturday
        seconds = t.second_of_week-1.hour
        time    = RecurringScheduleSlot.as_time(seconds)
        time.hour.should eq 11
        time.wday.should eq 6
      end
    end
    
    context "DST -> not-DST" do
      it "returns the time that is specified in DB, not the server-adjusted time" do
        t       = freeze_time_at Time.new(2012, 11, 4, 0, 0, 0) # DST ends at 2am, goes back to 1am on this date
        seconds = (t+3.hours).second_of_week # 3am
        time    = RecurringScheduleSlot.as_time(seconds)
        time.hour.should eq 3
        time.wday.should eq 0
      end
    end
    
    context "not-DST -> DST" do
      it "returns the time specified in the DB" do
        t       = freeze_time_at Time.new(2012, 3, 11, 0, 0, 0) # DST starts at 2am, goes forward to 3am on this date
        seconds = t.second_of_week+3.hours
        time    = RecurringScheduleSlot.as_time(seconds)
        time.hour.should eq 3
        time.wday.should eq 0
      end
    end
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
        RecurringScheduleSlot.on_at(Chronic.parse("Saturday 10:59:59pm")).should eq []
        RecurringScheduleSlot.on_at(Chronic.parse("Sunday 3am")).should eq []
      end
    end
    
    context "daylight savings time" do
      before :each do
        # DST "Fall back" 2am -> 1am on November 4, 2012
        t = Time.new(2012, 11, 3, 23)
        @slot = create :recurring_schedule_slot, start_time: t.second_of_week, end_time: (t+4.hours).second_of_week
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

  describe "#starts_at" do
    context "slot is past" do
      it "returns the time with next week's date" do
        t = freeze_time_at Time.new(2012, 10, 30, 12, 0)
        
        slot = create :recurring_schedule_slot, start_time: t.second_of_week-4.hours, end_time: t.second_of_week-2.hours
        slot.starts_at.should eq t+1.week-4.hours
      end
    end
    
    context "slot is current" do
      it "returns the time with this week's date" do
        t = freeze_time_at Time.new(2012, 10, 30, 12, 0)
        slot = create :recurring_schedule_slot, start_time: (t-2.hours).second_of_week, end_time: (t+2.hours).second_of_week
        slot.starts_at.should eq Time.at(t-2.hours)
      end
    end
    
    context "slot is upcoming" do
      it "returns the time with this week's date" do
        t = freeze_time_at Time.new(2012, 10, 30, 12, 0)
        slot = create :recurring_schedule_slot, start_time: (t+2.hours).second_of_week, end_time: (t+4.hours).second_of_week
        slot.starts_at.should eq Time.at(t+2.hours)
      end
    end
  end

  #------------
  
  describe "#ends_at" do
    context "slot is past" do
      it "returns the time with next week's date" do
        t = freeze_time_at Time.new(2012, 10, 30, 12, 0)
        slot = create :recurring_schedule_slot, start_time: (t-4.hours).second_of_week, end_time: (t-2.hours).second_of_week
        slot.starts_at.should eq Time.at(t+1.week-4.hours)
      end
    end
    
    context "slot is current" do
      it "returns the time with this week's date" do
        t = freeze_time_at Time.new(2012, 10, 30, 12, 0)
        slot = create :recurring_schedule_slot, start_time: (t-2.hours).second_of_week, end_time: (t+2.hours).second_of_week
        slot.starts_at.should eq Time.at(t-2.hours)
      end
    end
    
    context "slot is upcoming" do
      it "returns the time with this week's date" do
        t = freeze_time_at Time.new(2012, 10, 30, 12, 0)
        slot = create :recurring_schedule_slot, start_time: (t+2.hours).second_of_week, end_time: (t+4.hours).second_of_week
        slot.starts_at.should eq Time.at(t+2.hours)
      end
    end
  end
  
  #------------

  describe "#day" do
    it "returns the wday" do
      t = freeze_time_at Time.new(2012, 10, 30, 12, 0) # Tuesday
      slot = create :recurring_schedule_slot, start_time: t.second_of_week, end_time: t.second_of_week+2.hours
      slot.day.should eq 2
    end
  end

  #------------

  describe "#past?" do
    it "is true if slot is past" do
      t = freeze_time_at Time.new(2012, 10, 30, 12, 0) # Tuesday
      slot = create :recurring_schedule_slot, start_time: t.second_of_week-4.hours, end_time: t.second_of_week-2.hours
      slot.past?.should eq true
    end
    
    it "is false if slot is current" do
      t = freeze_time_at Time.new(2012, 10, 30, 12, 0) # Tuesday
      slot = create :recurring_schedule_slot, start_time: t.second_of_week-2.hours, end_time: t.second_of_week+2.hours
      slot.past?.should eq false
    end
    
    it "is false if slot is upcoming" do
      t = freeze_time_at Time.new(2012, 10, 30, 12, 0) # Tuesday
      slot = create :recurring_schedule_slot, start_time: t.second_of_week+2.hours, end_time: t.second_of_week+4.hours
      slot.past?.should eq false
    end
  end
  
  #------------

  describe "#current?" do
    it "is false if slot is past" do
      t = freeze_time_at Time.new(2012, 10, 30, 12, 0) # Tuesday
      slot = create :recurring_schedule_slot, start_time: t.second_of_week-4.hours, end_time: t.second_of_week-2.hours
      slot.current?.should eq false
    end
    
    it "is true if slot is current" do
      t = freeze_time_at Time.new(2012, 10, 30, 12, 0) # Tuesday
      slot = create :recurring_schedule_slot, start_time: t.second_of_week-2.hours, end_time: t.second_of_week+2.hours
      slot.current?.should eq true
    end
    
    it "is false if slot is upcoming" do
      t = freeze_time_at Time.new(2012, 10, 30, 12, 0) # Tuesday
      slot = create :recurring_schedule_slot, start_time: t.second_of_week+2.hours, end_time: t.second_of_week+4.hours
      slot.current?.should eq false
    end
    
    context "split weeks" do
      pending
    end
  end
  
  #------------

  describe "#upcoming?" do
    it "is false if slot is past" do
      t = freeze_time_at Time.new(2012, 10, 30, 12, 0) # Tuesday
      slot = create :recurring_schedule_slot, start_time: t.second_of_week-4.hours, end_time: t.second_of_week-2.hours
      slot.upcoming?.should eq false
    end
    
    it "is true if slot is current" do
      t = freeze_time_at Time.new(2012, 10, 30, 12, 0) # Tuesday
      slot = create :recurring_schedule_slot, start_time: t.second_of_week-2.hours, end_time: t.second_of_week+2.hours
      slot.upcoming?.should eq false
    end
    
    it "is false if slot is upcoming" do
      t = freeze_time_at Time.new(2012, 10, 30, 12, 0) # Tuesday
      slot = create :recurring_schedule_slot, start_time: t.second_of_week+2.hours, end_time: t.second_of_week+4.hours
      slot.upcoming?.should eq true
    end
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
