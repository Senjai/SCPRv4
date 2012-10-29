require "spec_helper"

describe Schedule do
  describe "::on_at" do
    it "sends it off to RecurringScheduleSlot::on_at" do
      t = Time.now
      RecurringScheduleSlot.should_receive(:on_at).with(t)
      Schedule.on_at(t)
    end
  end
  
  #------------
  
  describe "::block" do
    it "sends it off to RecurringScheduleSlot::block" do
      t = Time.now
      RecurringScheduleSlot.should_receive(:block).with(t, 8.hours)
      Schedule.block(t, 8.hours)
    end
  end
end
