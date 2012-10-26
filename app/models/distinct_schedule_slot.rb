class DistinctScheduleSlot < ActiveRecord::Base
  has_secretary
  
  #--------------
  # Validations
  validates :starts_at, :ends_at, :title, presence: true
end
