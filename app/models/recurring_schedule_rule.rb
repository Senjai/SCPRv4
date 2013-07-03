# RecurringScheduleRule
#
# A recurring program on the schedule
class RecurringScheduleRule < ActiveRecord::Base
  include IceCube

  serialize :schedule, Hash

  outpost_model
  has_secretary

  include Concern::Associations::PolymorphicProgramAssociation
  include Concern::Callbacks::SphinxIndexCallback

  DEFAULT_DURATION = 1.month

  #--------------
  # Scopes

  #--------------
  # Associations
  has_many :schedule_occurrences, dependent: :destroy

  #--------------
  # Validations
  validates :program, presence: true
  validates :schedule, presence: true
  validates :time_of_day, presence: true

  #--------------
  # Callbacks

  #before_save :merge_time_of_day_into_rule
  before_create :build_occurrences
  before_update :rebuild_occurrences, if: -> { self.schedule_changed? }

  #--------------
  # Sphinx  
  define_index do
    indexes program.title
    indexes schedule
  end

  attr_accessor :time_of_day

  def purge_past_occurrences(threshold = nil)
    threshold ||= 1.month.ago
    self.schedule_occurrences.before(threshold).destroy_all
  end


  def rebuild_occurrences(options = {})
    options[:rebuild] = true
    build_occurrences(options)
  end


  def recreate_occurrences(options = {})
    options[:rebuild] = true
    create_occurrences(options)
  end


  # Build a block of occurrences of this rule.
  # This denormalization allows us to easily query for blocks of 
  # schedule.
  #
  # Options:
  # * start_date - the date to start building
  #                default: occurrence after the last
  # * end_date   - the date to end building.
  #                default: start_date + 1 month
  #
  # Building events should be staggered. 
  # You should build a month's worth of schedule, 
  # starting at the beginning of the previous month, so you're 
  # always a month ahead. This is just an example.
  #
  # Here's a diagram, for the visual learners out there:
  #
  #
  # DAY            :    01        01        01        01        01       ...
  # CURRENT MONTH  :    |---JAN---|---FEB---|---MAR---|---APR---|---JUN---|
  #                               |         |         |         |         |
  # BUILD SCH. FOR :             MAR       APR       JUN       JUL       etc
  #
  #
  # The periodic schedule building can be done by a cron job,
  # or lazily if you're feeling ambitious.
  #
  # By default (with no options passed in), this will build 
  # a month worth of schedule starting at the occurrence following
  # the last one built (or now if none exist).
  #
  # Changing past occurrences is not recommneded. But, do whatever you
  # want. I'm just some letters in a file. You don't have to listen to me.
  def build_occurrences(options = {})
    # * If start_date was passed in, use it.
    # * Next try the start time of the occurrence after the last occurrence.
    #   Got it? No? Me neither.
    # * IceCube defaults to Time.now if `nil` is passed in to
    #   `next_occurrence`, so that will be the fallback.
    start_date = options[:start_date] ||
      self.schedule.next_occurrence(
        self.schedule_occurrences.future.last.try(:starts_at)
      ) || Time.now

    end_date = options[:end_date] || (start_date + DEFAULT_DURATION)

    existing = existing_occurrences_between(start_date, end_date)
    
    # Destroy existing occurrences inside the range
    # if a rebuild was requested.
    if options[:rebuild]
      existing.each_value { |o| o.destroy }
      existing = {}
    end

    # We don't want to duplicate occurrences that already exist
    # for this rule.
    self.schedule(start_date_override: start_date)
    .occurrences(end_date)
    .reject { |o| existing[o.start_time] }
    .each do |occurrence|
      self.schedule_occurrences.build(
        :starts_at => occurrence.start_time,
        :ends_at   => occurrence.end_time,
        :program   => self.program
      )
    end
  end


  def create_occurrences(options = {})
    build_occurrences(options)
    self.save
  end


  def schedule=(new_schedule)
    @schedule = rule(new_schedule).to_hash
  end

  def schedule(options={})
    Schedule.from_hash(read_attribute(:schedule), options)
  end


  private

  def rule(rule_or_hash)
    rule = RecurringSelect.dirty_hash_to_rule(rule_or_hash)

    if @time_of_day
      hour, minute = @time_of_day.split(":")
      rule = rule.hour_of_day(hour).minute_of_hour(minute).second_of_minute(0)
    end

    rule
  end

  def merge_time_of_day_into_rule
    rule
  end

  def existing_occurrences_between(start_date, end_date)
    existing = {}
    
    self.schedule_occurrences.between(start_date, end_date).each do |occurrence|
      existing[occurrence.starts_at] = occurrence
    end
    
    existing
  end
end
