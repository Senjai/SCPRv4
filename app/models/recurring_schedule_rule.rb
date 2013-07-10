# RecurringScheduleRule
#
# A recurring program on the schedule
#
# `start_time` and `end_time` are denormalized mostly just
# for the form. We could figure those attributes out from
# the `schedule_hash` but it's easier this way.
class RecurringScheduleRule < ActiveRecord::Base
  include IceCube

  serialize :schedule_hash, Hash
  serialize :days, Array

  outpost_model
  has_secretary

  include Concern::Associations::PolymorphicProgramAssociation
  include Concern::Callbacks::SphinxIndexCallback

  DEFAULT_DURATION          = 1.month
  DEFAULT_PURGE_THRESHOLD   = 1.month.ago
  DEFAULT_INTERVAL          = 1

  # Define a custom DAYS array so we can control the order.
  DAYS = [
    ["Monday", 1],
    ["Tuesday", 2],
    ["Wednesday", 3],
    ["Thursday", 4],
    ["Friday", 5],
    ["Saturday", 6],
    ["Sunday", 0]
  ]


  #--------------
  # Scopes


  #--------------
  # Associations
  has_many :schedule_occurrences, dependent: :destroy


  #--------------
  # Validations
  validate :program_is_present

  validates :interval, presence: true
  validates :days, presence: true

  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :time_fields_are_present


  #--------------
  # Callbacks
  before_save :build_schedule, if: :rule_changed?
  before_create :build_occurrences, if: -> { self.schedule_occurrences.blank? }
  before_update :rebuild_occurrences, if: :rule_changed?
  before_save :update_occurrence_program, if: :program_changed?

  #--------------
  # Sphinx
  define_index do
    has :id # just so the Search in outpost can be ordered.
    indexes program.title
    indexes schedule_hash
  end


  class << self
    def create_occurrences(options={})
      self.all.each do |rule|
        rule.create_occurrences(options)
      end
    end
  end


  def schedule=(new_schedule)
    self.schedule_hash = new_schedule.try(:to_hash)
  end

  def schedule(options={})
    if self.schedule_hash.present?
      IceCube::Schedule.from_hash(self.schedule_hash, options)
    end
  end


  def duration
    @duration ||= begin
      start_time_seconds = calculate_seconds(parse_time_string(self.start_time))
      end_time_seconds   = calculate_seconds(parse_time_string(self.end_time))

      return 0 unless start_time_seconds && end_time_seconds

      if start_time_seconds <= end_time_seconds
        end_time_seconds - start_time_seconds
      else
        1.day - start_time_seconds + end_time_seconds
      end
    end
  end


  def build_schedule
    self.schedule = ScheduleBuilder.build_schedule(
      :interval     => self.interval,
      :days         => self.days,
      :start_time   => self.start_time,
      :end_time     => self.end_time
    )
  end


  def purge_past_occurrences(threshold = nil)
    threshold ||= DEFAULT_PURGE_THRESHOLD
    self.schedule_occurrences.before(threshold).destroy_all
  end


  # Build a block of occurrences of this rule.
  # This denormalization allows us to easily query for blocks of
  # schedule.
  #
  # Options:
  # * start_date - the date to start building
  #                default: now
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
  # want. I'm just some words in a file. You don't have to listen to me.
  def build_occurrences(options = {})
    start_date  = options[:start_date] || Time.now
    end_date    = options[:end_date] || (start_date + DEFAULT_DURATION)

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
        :ends_at   => occurrence.start_time + self.duration,
        :program   => self.program
      )
    end

    self.schedule_occurrences
  end


  # Convenience methods for building/creating

  # Build and save
  def create_occurrences(options = {})
    build_occurrences(options)
    self.save
  end

  # Rebuild, but do not save
  def rebuild_occurrences(options = {})
    options[:rebuild] = true
    build_occurrences(options)
  end

  # Rebuild and save
  def recreate_occurrences(options = {})
    options[:rebuild] = true
    create_occurrences(options)
  end



  private

  # For the form...
  def program_is_present
    if self.program.blank?
      self.errors.add(:program_obj_key, "can't be blank.")
    end
  end

  def time_fields_are_present
    if self.start_time.blank? || self.end_time.blank?
      self.errors.add(:time, "can't be blank.")
    end
  end


  def update_occurrence_program
    self.schedule_occurrences.update_all(
      :program_id   => self.program_id,
      :program_type => self.program_type
    )
  end


  def parse_time_string(string)
    string.to_s.split(":").map(&:to_i)
  end

  def calculate_seconds(time_parts)
    return nil if time_parts.empty?
    time_parts[0] * 60 * 60 + time_parts[1] * 60
  end


  def duration_should_change?
    self.start_time_changed? ||
    self.end_time_changed?
  end

  def rule_changed?
    self.interval_changed? ||
    self.days_changed? ||
    self.start_time_changed? ||
    self.end_time_changed?
  end

  def program_changed?
    self.program_id_changed? || self.program_type_changed?
  end


  def rule_hash
    @rule_hash ||= self.schedule.recurrence_rules.first.try(:to_hash) || {}
  end

  def existing_occurrences_between(start_date, end_date)
    existing = {}

    self.schedule_occurrences.between(start_date, end_date).each do |occurrence|
      existing[occurrence.starts_at] = occurrence
    end

    existing
  end
end
