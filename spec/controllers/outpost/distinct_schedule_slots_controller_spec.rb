require "spec_helper"

describe Outpost::DistinctScheduleSlotsController do
  it_behaves_like "resource controller" do
    let(:resource) { :distinct_schedule_slot }
  end
end
