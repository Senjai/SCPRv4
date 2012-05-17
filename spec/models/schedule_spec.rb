require "spec_helper"

describe Schedule do
  describe "show_modal" do
    let(:schedule) { create :schedule }
    
    it "returns false if program does not display_episodes" do
      program = build :kpcc_program, display_episodes: false
      schedule.stub(:programme) { program }
      schedule.show_modal?.should be_false
    end
    
    it "returns false if program does not have any published episodes" do
      program = build :kpcc_program, display_episodes: true, episode_count: 0
      schedule.stub(:programme) { program }
      schedule.show_modal?.should be_false
    end
    
    it "returns false if current episode doesn't have any published segments" do
      program = create :kpcc_program, display_episodes: true, episode_count: 1, segment_count: 0
      schedule.stub(:programme) { program }
      schedule.show_modal?.should be_false
    end
    
    it "returns true if everything above is true" do
      program = create(:kpcc_program, display_episodes: true, episode_count: 1, episode: { segment_count: 1 })
      schedule.stub(:programme) { program }
      schedule.show_modal?.should be_true
    end
  end
  
  describe "formnat_time" do
    it "returns noon if the time is noon" do
      schedule = build :schedule, start_time: Chronic.parse("12pm")
      schedule.format_time.should eq "noon"
    end
    
    it "returns midnight if the time is midnight" do
      schedule = build :schedule, start_time: Chronic.parse("12am")
      schedule.format_time.should eq "midnight"
    end
    
    it "returns minutes if it doesn't start on the top of the hour" do
      schedule = build :schedule, start_time: Chronic.parse("12:30pm")
      schedule.format_time.should match /\:30/
    end
    
    it "returns only the hour and am/pm if starts on the hour" do
      schedule = build :schedule, start_time: Chronic.parse("1pm")
      schedule.format_time.should_not match /\:00/
    end
  end
end