# ScheduleOccurrence
class ScheduleOccurrence < ActiveRecord::Base
  outpost_model
  has_secretary

  include Concern::Associations::PolymorphicProgramAssociation
  include Concern::Callbacks::TouchCallback

############################

  scope :after,   ->(time) { where("starts_at > ?", time).order("starts_at") }
  scope :before,  ->(time) { where("ends_at < ?", time).order("starts_at") }
  scope :future,  -> { after(Time.now) }
  scope :past,    -> { before(Time.now) }
  scope :current, -> { at(Time.now) }


  scope :between, ->(start_date, end_date) { 
    where("starts_at < ? and ends_at > ?", end_date, start_date)
    .order("starts_at")
  }

  scope :at, ->(date) {
    where("starts_at <= :date and ends_at > :date", date: date)
    .order("starts_at")
  }


  scope :recurring, -> { where("recurring_schedule_rule_id is not null") }
  scope :distinct,  -> { where("recurring_schedule_rule_id is null") }

  scope :filtered_by_date, ->(date) { where("DATE(starts_at) = ?", date) }

############################

  validate :program_or_info_is_present
  validates :info_url, url: { allow_blank: true }


  belongs_to :recurring_schedule_rule

  before_update :detach_from_recurring_rule, if: -> {
    self.is_recurring? && (self.starts_at_changed? || self.ends_at_changed?)
  }

  define_index do
    indexes event_title
    indexes program.title
    indexes info_url

    has updated_at
    has starts_at
  end


  class << self
    def program_select_collection
      kpcc_programs     = KpccProgram.all.map { |p| [p.title, p.obj_key] }
      external_programs = ExternalProgram.all.map { |p| [p.title, p.obj_key] }
      kpcc_programs + external_programs
    end


    def date_select_collection
      self.select("distinct DATE(starts_at) as date")
      .order('date desc').map(&:date)
    end

    # Find the occurrence on at the requested date.
    # Distinct slots have higher priority. If there are any
    # distinct slots on at this date, then it will be returned.
    # Otherwise, it will return the first (recurring) slot.
    def on_at(date)
      occurrences = self.at(date)
      occurrences.find(&:is_distinct?) || occurrences.first
    end


    def block(date, length)
      occurrences = self.between(date, date + length)

      occurrences.reject do |occurrence|
        occurrences.any? do |o|
          o != occurrence && o.is_distinct? &&
          o.starts_at <= occurrence.starts_at &&
          o.ends_at >= occurrence.ends_at
        end
      end
    end
  end


  def wday
    self.starts_at.wday
  end

  def duration
    self.ends_at.to_i - self.starts_at.to_i
  end

  def is_recurring?
    self.recurring_schedule_rule_id.present?
  end

  def is_distinct?
    !self.is_recurring?
  end



  def following_occurrence
    between = ScheduleOccurrence.between(Time.now, self.ends_at + 1)
    between.find { |o| o != self }
  end


  # Validations will ensure that either the program or the event_title 
  # is present.
  def title
    self.event_title.present? ? self.event_title : self.program.title
  end

  def public_url
    self.info_url.present? ? self.info_url : self.program.public_url
  end


  # This is for the listen live JS.
  def listen_live_json
    {
      :start => self.starts_at.to_i,
      :end   => self.ends_at.to_i,
      :title => self.title,
      :link  => self.public_url
    }
  end


  private

  def detach_from_recurring_rule
    self.recurring_schedule_rule = nil
  end

  def program_or_info_is_present
    if self.program.blank? && (self.info_url.blank? || self.event_title.blank?)
      self.errors.add(:base, "Program or Info URL/Title must be present.")
    end
  end
end
