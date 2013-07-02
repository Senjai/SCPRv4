require "spec_helper"

describe ScheduleOccurrence do
  describe "::on_at" do
    it "selects the first distinct slot if it's present" do
      occurrence = create :schedule_occurrence

      ScheduleOccurrence.on_at(occurrence.starts_at).should eq occurrence
    end

    it "gets the first recurring slot if no distinct slots are present" do
      occurrence = create :schedule_occurrence, :recurring
      ScheduleOccurrence.on_at(occurrence.starts_at).should eq occurrence
    end
  end

  #------------

  describe "#next" do
    it "selects the slot immediately following this one" do
    end
  end

  #------------

  describe "#listen_live_json" do
    it "is a thing, which does stuff" do
      occurrence = create :schedule_occurrence
      occurrence.listen_live_json
    end
  end
end
