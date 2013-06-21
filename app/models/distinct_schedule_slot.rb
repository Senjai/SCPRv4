class DistinctScheduleSlot < ActiveRecord::Base
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
end
