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
  
  before_save :set_default_agree_count
  before_save :set_default_status
  
  def set_default_agree_count
    self.agrees = 1
  end
  
  def set_default_status
    self.status = STATUS_OPEN
  end
end
