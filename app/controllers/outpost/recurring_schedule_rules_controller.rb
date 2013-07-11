class Outpost::RecurringScheduleRulesController < Outpost::ResourceController
  outpost_controller
  before_filter :clean_days, only: [:create, :update]

  define_list do |l|
    l.per_page = 200

    l.column :program, display: ->(r) { r.program.title }
    l.column :schedule, header: "Rule", display: ->(r) { r.schedule.to_s }
  end


  private

  def clean_days
    params[:recurring_schedule_rule][:days] = 
      params[:recurring_schedule_rule][:days].reject(&:blank?).map(&:to_i)
  end
end
