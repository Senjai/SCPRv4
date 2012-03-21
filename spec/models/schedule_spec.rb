require "spec_helper"

describe Schedule do
  describe "show_modal" do
    let(:schedule) { create :schedule }
    
    it "returns false if program does not display_episodes" do
      schedule.stub(:programme) { build :kpcc_program, display_episodes: false }
      schedule.show_modal?.should be_false
    end
    
    it "returns false if program does not have any published episodes" do
      schedule.stub(:programme) { build :kpcc_program, display_episodes: true, episode_count: 0 }
      schedule.show_modal?.should be_false
    end
    
    it "returns false if current episode doesn't have any published segments" do
      schedule.stub(:programme) { create :kpcc_program, display_episodes: true, episode_count: 1, segment_count: 0 }
      schedule.show_modal?.should be_false
    end
    
    it "returns true if everything above is true" do
      schedule.stub(:programme) { create :kpcc_program, display_episodes: true, episode_count: 1, segment_count: 1 }
      schedule.show_modal?.should be_true
    end
  end
end