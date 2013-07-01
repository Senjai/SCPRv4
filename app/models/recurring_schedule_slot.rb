# RecurringScheduleSlot
#
# A recurring program on the schedule
class RecurringScheduleSlot < ScheduleSlot
  include IceCube

  serialize :schedule, Hash

  outpost_model
  has_secretary

  include Concern::Callbacks::SphinxIndexCallback

  INPUT_FORMAT = %r|(?<day>[a-zA-Z]+) +(?<hour>\d\d?)\:(?<min>\d\d)|

  # Because Time::DAYS_INTO_WEEK starts on Monday,
  # but we've decided to start on Sunday.
  DAYS_INTO_WEEK = {
    :sunday       => 0,
    :monday       => 1,
    :tuesday      => 2,
    :wednesday    => 3,
    :thursday     => 4,
    :friday       => 5,
    :saturday     => 6
  }

  #--------------
  # Scopes

  #--------------
  # Associations
  belongs_to :program, polymorphic: true
  has_many :schedule_occurrences

  #--------------
  # Validations
  validates :program, presence: true 
  validate :time_strings_can_be_parsed

  #--------------
  # Callbacks
  before_validation :set_program_from_obj_key
  before_save :set_times_from_input_strings

  #--------------
  # Sphinx  
  define_index do
    indexes program.title
    has start_time
  end


  class << self
    def program_select_collection
      kpcc_programs  = KpccProgram.all.map { |p| [p.title, p.obj_key] }
      other_programs = OtherProgram.all.map { |p| [p.title, p.obj_key] }
      kpcc_programs + other_programs
    end

    def build_future_occurrences
      self.all.each do |slot|
        # do magic
      end
    end
  end


  def rebuild_future_occurrences
    self.schedule_occurrences.future.destroy_all
    build_future_occurrences
  end

  def build_future_occurrences(duration = 1.month)
    self.schedule.occurrences(Time.now + duration).each do |occurrence|
      self.schedule_occurrences.build(
        :starts_at => occurrence.start_time,
        :ends_at   => occurrence.end_time,
        :program   => self.program
      )
    end
  end


  def schedule=(new_schedule)
    write_attribute(:schedule, new_schedule.to_hash)
  end

  def schedule
    Schedule.from_hash(read_attribute(:schedule))
  end


  attr_writer \
    :program_obj_key,
    :start_time_string,
    :end_time_string

  def program_obj_key
    @program_obj_key || self.program.try(:obj_key)
  end



  def title
    self.program.title
  end

  def public_url
    self.program.public_url
  end


  private

  def set_program_from_obj_key
    self.program = Outpost.obj_by_key(self.program_obj_key)
  end
end
