##
# RecurringScheduleSlot
#
# A recurring program on the schedule
# The `start_time` and `end_time` attributes are
# the number of _seconds_ from the beginning of the week.
#
class RecurringScheduleSlot < ActiveRecord::Base
  DATE_ANCHOR = Time.new(2000, 01, 01)
  
  has_secretary
  
  #--------------
  # Associations
  belongs_to :program, polymorphic: true


  #--------------
  # Validations  
  validates :start_time, :end_time, :program, presence: true


  #--------------
  # Scopes
  scope :on_at, ->(time) { where("start_time <= :time and :time < end_time", time: time.second_of_week).order("start_time desc") }
  scope :between

  #--------------
  
  class << self
    #--------------
    # Convert the stored relative minute
    # count into a real Time object.
    # Uses Rails' convention of setting
    # the date to 2000/01/01 for now, so
    # the listen live JS remains functional.
    def as_time(seconds)
      Time.at(DATE_ANCHOR.to_i + seconds)
    end
  end
  
  #--------------
  # Fake attributes to return real Time objects
  def starts_at
    @starts_at ||= self.class.as_time(self.start_time)
  end
  
  def ends_at
    @ends_at ||= self.class.as_time(self.end_time)
  end

  #--------------
  
  def json
    {
      :start => self.starts_at,
      :end   => self.ends_at,
      :title => self.program.title,
      :link  => self.program.link_path
    }
  end

  #--------------
  #--------------
  # TODO Move these to a Presenter
  def show_modal?
    program.display_episodes
  end
  
  def format_time
    str_time = self.starts_at.strftime("%H:%M")
    
    if str_time == "00:00"
      "midnight"
    elsif str_time == "12:00"
      "noon"
    elsif str_time.match /:00/
      self.starts_at.strftime("%l%P")
    else
      self.starts_at.strftime("%l:%M%P")
    end
  end
end
