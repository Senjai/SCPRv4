class Ticket < ActiveRecord::Base
  outpost_model
  has_secretary

  STATUS_OPEN   = 1
  STATUS_CLOSED = 0
  
  STATUS_TEXT = {
    STATUS_OPEN   => "Open",
    STATUS_CLOSED => "Closed"
  }

  #--------------------
  # Scopes
  scope :opened,   -> { where(status: STATUS_OPEN) }
  scope :closed, -> { where(status: STATUS_CLOSED) }
  
  #--------------------
  # Association  
  belongs_to :user, class_name: "AdminUser"
  
  #--------------------
  # Callbacks
  before_save :set_default_status, if: -> { self.status.blank? }
  after_save :publish_ticket_to_redis, if: :status_changed?
  
  def set_default_status
    self.status = STATUS_OPEN
  end

  #--------------------
  
  def publish_ticket_to_redis
    text_status = self.status == STATUS_OPEN ? "Opened" : "Closed"
    $redis.publish "scpr-tickets", "** Ticket #{text_status}: \"#{self.summary}\" (#{self.user.name}) (http://scpr.org#{self.admin_show_path})"
  end
  
  #--------------------
  # Validations
  validates :user, presence: true
  validates :summary, presence: true

  #--------------------
  # Sphinx
  acts_as_searchable
  
  define_index do
    indexes summary
    indexes description
    indexes browser_info

    has id
    has created_at
    has status
  end
  
  #--------------------
  
  attr_accessor :user_name # just for the form
  
  class << self
    def status_text_collection
      STATUS_TEXT.map { |k, v| [v, k] }
    end
  end
end
