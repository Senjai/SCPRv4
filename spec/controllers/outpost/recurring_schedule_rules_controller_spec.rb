require "spec_helper"

describe Outpost::RecurringScheduleRulesController do
  render_views

  before :each do
    @admin_user = create :admin_user
    controller.stub(:current_user) { @admin_user }
  end

  describe 'day param' do
    it "removes blank items" do
      program = create :kpcc_program

      post :create, recurring_schedule_rule: {
        :interval           => 1,
        :days               => ["1", "2", "3","4", ""],
        :start_time         => "9:00",
        :end_time           => "11:00",
        :program_obj_key    => program.obj_key
      }

      controller.params[:recurring_schedule_rule][:days].should_not include ""
    end
  end
end
