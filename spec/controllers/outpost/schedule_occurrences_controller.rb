require "spec_helper"

describe Outpost::ScheduleOccurrencesController do
  it_behaves_like "resource controller" do
    let(:resource) { :schedule_occurrence }
  end
end
