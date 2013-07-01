# ScheduleOccurrence
class ScheduleOccurrence < ActiveRecord::Base
  outpost_model
  has_secretary

  # This is for the listen live JS.
  def listen_live_json
    {
      :start => self.starts_at.to_i,
      :end   => self.ends_at.to_i,
      :title => self.title,
      :link  => self.public_url
    }
  end

end
