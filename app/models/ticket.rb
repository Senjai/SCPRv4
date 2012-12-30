class Ticket < ActiveRecord::Base
  STATUS_OPEN   = 1
  STATUS_CLOSED = 0
  
  STATUS_TEXT = {
    STATUS_OPEN   => "Open",
    STATUS_CLOSED => "Closed"
  }
  
  scope :open,   -> { where(status: STATUS_OPEN) }
  scope :closed, -> { where(status: STATUS_CLOSED) }
  
  belongs_to :user, class_name: "AdminUser"
end
