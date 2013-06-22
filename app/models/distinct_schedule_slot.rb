class DistinctScheduleSlot < ScheduleSlot
  outpost_model
  has_secretary
  
  #--------------
  # Validations
  validates :starts_at, :ends_at, :title, presence: true
  validates :info_url, url: { allow_blank: true }

  define_index do
    indexes title
    indexes info_url
    has starts_at
  end

  class << self
    def on_at(time)
      block(time, 0).first
    end

    # Keep in mind that we're not talking about starts_at
    # ends_at with these arguments. These arguments are
    # about the time that I'm interested in knowing what's on.
    #
    # It's concering real-world time. Therefore, we query
    # the database for anything that starts before the
    # block end time, and which ends after the block's start
    # time.
    #
    # Here's a "Back to the Future"-style diagram:
    #
    #     START                                  END (T+8 hours)
    #       |-------------------------------------|
    #     |-SLOT-|    |-SLOT-|   |-SLOT-|        |-SLOT-|
    #
    # Calling this method like `block(START, START+8 hours)`
    # will return all 4 slots, because even the two that
    # hang over the edges are still "on" during that time.
    #
    # This should return an array of what is on between
    # start_time and end_time.
    def block(start_time, length)
      end_time = start_time + length

      self.where("starts_at <= ? and ends_at > ?", end_time, start_time)
        .order("starts_at")
    end
  end
end
