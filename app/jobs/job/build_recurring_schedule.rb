module Job
  class BuildRecurringSchedule < Base
    @queue = "#{namespace}:rake_tasks"

    def self.perform
      next_month = Time.now.next_month
      start_date = next_month.beginning_of_month
      end_date   = next_month.end_of_month

      RecurringScheduleRule.create_occurrences(
        :start_date   => start_date,
        :end_date     => end_date
      )
    end
  end
end
