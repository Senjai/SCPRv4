class SeedRecurringSchedule < ActiveRecord::Migration
  def up
    programs = {}
    (KpccProgram.all + OtherProgram.all).each { |p| programs[p.slug] = p }

    t = Time.now.beginning_of_week
    
    r = RecurringScheduleRule.new(interval: 1, days: [1, 2, 3, 4, 5], start_time: "02:00", end_time: "09:00", program: programs["morning-edition"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [1, 2, 3, 4, 5], start_time: "09:00", end_time: "11:00", program: programs["take-two"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [1, 2, 3, 4, 5], start_time: "13:00", end_time: "14:00", program: programs["bbc-newshour"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [1, 2, 3, 4, 5], start_time: "14:00", end_time: "15:00", program: programs["world"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [1, 2, 3, 4, 5], start_time: "15:00", end_time: "15:30", program: programs["marketplace"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [1, 2, 3, 4, 5], start_time: "15:30", end_time: "18:30", program: programs["all-things-considered"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [1, 2, 3, 4, 5], start_time: "18:30", end_time: "19:00", program: programs["marketplace"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!



    r = RecurringScheduleRule.new(interval: 1, days: [1, 2, 3, 4], start_time: "11:00", end_time: "13:00", program: programs["airtalk"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [1, 2, 3, 4], start_time: "19:00", end_time: "20:00", program: programs["fresh-air"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [1, 2, 3, 4], start_time: "20:00", end_time: "21:00", program: programs["take-two-evenings"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [1, 2, 3, 4], start_time: "21:00", end_time: "22:00", program: programs["tell-me-more"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [1, 2, 3, 4], start_time: "22:00", end_time: "23:00", program: programs["story"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [1, 2, 3, 4], start_time: "23:00", end_time: "02:00", program: programs["bbc-world-service"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!



    r = RecurringScheduleRule.new(interval: 1, days: [1], start_time: "00:00", end_time: "02:00", program: programs["bbc-world-service"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!



    r = RecurringScheduleRule.new(interval: 1, days: [5], start_time: "11:00", end_time: "12:00", program: programs["airtalk"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [5], start_time: "12:00", end_time: "13:00", program: programs["filmweek"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [5], start_time: "19:00", end_time: "20:00", program: programs["dinner-party-download"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [5], start_time: "20:00", end_time: "21:00", program: programs["this-american-life"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [5], start_time: "21:00", end_time: "23:00", program: programs["science-friday"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [5], start_time: "23:00", end_time: "00:00", program: programs["radiolab"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!



    r = RecurringScheduleRule.new(interval: 1, days: [6, 0], start_time: "10:00", end_time: "11:00", program: programs["car-talk"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [6, 0], start_time: "11:00", end_time: "12:00", program: programs["wait-wait-dont-tell-me"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [6, 0], start_time: "17:00", end_time: "18:00", program: programs["all-things-considered"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!


    
    r = RecurringScheduleRule.new(interval: 1, days: [6], start_time: "00:00", end_time: "05:00", program: programs["bbc-world-service"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [6], start_time: "05:00", end_time: "10:00", program: programs["weekend-edition-saturday"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [6], start_time: "12:00", end_time: "13:00", program: programs["offramp"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [6], start_time: "13:00", end_time: "14:00", program: programs["this-american-life"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [6], start_time: "14:00", end_time: "15:00", program: programs["ted-radio-hour"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [6], start_time: "15:00", end_time: "16:00", program: programs["bullseye"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [6], start_time: "16:00", end_time: "17:00", program: programs["snap-judgment"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [6], start_time: "18:00", end_time: "20:00", program: programs["prairie-home-companion"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [6], start_time: "20:00", end_time: "21:00", program: programs["wits"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [6], start_time: "21:00", end_time: "22:00", program: programs["ask-me-another"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [6], start_time: "22:00", end_time: "23:00", program: programs["tavis-smiley-show"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [6], start_time: "23:00", end_time: "05:00", program: programs["bbc-world-service"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!



    r = RecurringScheduleRule.new(interval: 1, days: [0], start_time: "05:00", end_time: "10:00", program: programs["weekend-edition-sunday"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [0], start_time: "12:00", end_time: "14:00", program: programs["prairie-home-companion"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [0], start_time: "14:00", end_time: "15:00", program: programs["moth-radio-hour"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [0], start_time: "15:00", end_time: "16:00", program: programs["snap-judgment"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [0], start_time: "16:00", end_time: "17:00", program: programs["radiolab"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [0], start_time: "18:00", end_time: "19:00", program: programs["offramp"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [0], start_time: "19:00", end_time: "20:00", program: programs["splendid-table"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [0], start_time: "20:00", end_time: "20:30", program: programs["latino-usa"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [0], start_time: "20:30", end_time: "21:00", program: programs["california-report"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [0], start_time: "21:00", end_time: "22:00", program: programs["speaking-faith"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [0], start_time: "22:00", end_time: "23:00", program: programs["on-the-media"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!

    r = RecurringScheduleRule.new(interval: 1, days: [0], start_time: "23:00", end_time: "00:00", program: programs["marketplace-money"])
    r.build_schedule
    r.build_occurrences(start_date: t)
    r.save!
  end


  def down
    RecurringScheduleRule.destroy_all
  end
end
