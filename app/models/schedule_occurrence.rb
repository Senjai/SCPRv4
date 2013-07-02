# ScheduleOccurrence
class ScheduleOccurrence < ActiveRecord::Base
  outpost_model
  has_secretary

  include Concern::Associations::PolymorphicProgramAssociation

  belongs_to :recurring_schedule_rule
  belongs_to :program, polymorphic: true


  scope :after,  ->(time) { where("starts_at > ?", time).order("starts_at") }
  scope :before, ->(time) { where("ends_at < ?", time).order("starts_at") }
  scope :future, -> { after(Time.now) }
  scope :past,   -> { before(Time.now) }

  scope :between, ->(start_date, end_date) { 
    where("starts_at >= ? and ends_at < ?", start_date, end_date)
    .order("starts_at")
  }

  scope :at, ->(date) {
    where("starts_at <= :date and ends_at > :date", date: date)
    .order("starts_at")
  }


  validate :program_or_info_is_present


  before_save :set_title, if: -> { self.title.blank? }
  before_save :set_info_url, if: -> { self.info_url.blank? }


  class << self
    def program_select_collection
      kpcc_programs  = KpccProgram.all.map { |p| [p.title, p.obj_key] }
      other_programs = OtherProgram.all.map { |p| [p.title, p.obj_key] }
      kpcc_programs + other_programs
    end


    # Find the occurrence on at the requested date.
    # Distinct slots have higher priority. If there are any
    # distinct slots on at this date, then it will be returned.
    # Otherwise, it will return the first (recurring) slot.
    def on_at(date)
      occurrences = self.at(date)
      occurrences.find { |o| o.is_distinct? } || occurrences.first
    end
  end


  def is_recurring?
    self.recurring_schedule_rule_id.present?
  end

  def is_distinct?
    !self.is_recurring?
  end


  # This is for the listen live JS.
  def listen_live_json
    {
      :start => self.starts_at.to_i,
      :end   => self.ends_at.to_i,
      :title => self.title,
      :link  => self.info_url
    }
  end


  private

  def program_or_info_is_present
    if self.program.blank? && (self.info_url.blank? || self.title.blank?)
      self.errors.add(:base, "Program or Info URL/Title must be present.")
    end
  end

  def set_title
    if self.title.blank? && self.program.present?
      self.title = self.program.title
    end
  end

  def set_info_url
    if self.info_url.blank? && self.program.present?
      self.info_url = self.program.public_url
    end
  end
end
