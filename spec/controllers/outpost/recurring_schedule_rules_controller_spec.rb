require "spec_helper"

describe Outpost::RecurringScheduleRulesController do
  it_behaves_like "resource controller" do
    let(:resource) { :recurring_schedule_slot }
  end
end
