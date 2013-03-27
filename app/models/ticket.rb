class Ticket < ActiveRecord::Base
  outpost_model
  has_secretary

  include Concern::Callbacks::SphinxIndexCallback

  STATUS_OPEN   = 0
  STATUS_CLOSED = 5
  
  STATUS_TEXT = {
    STATUS_OPEN   => "Open",
    STATUS_CLOSED => "Closed"
  }

  #--------------------
  # Scopes
  scope :opened, -> { where(status: STATUS_OPEN) }
  scope :closed, -> { where(status: STATUS_CLOSED) }
  
  #--------------------
  # Association  
  belongs_to :user, class_name: "AdminUser"
  
  #--------------------
  # Callbacks
  after_save :publish_ticket_to_redis, if: -> { self.opening? || self.closing? }

  #--------------------
  
  def open?
    self.status == STATUS_OPEN
  end

  def closed?
    self.status == STATUS_CLOSED
  end

  #--------------------

  def opening?
    (self.id_changed? && self.open?) || (self.status_was == STATUS_CLOSED && self.open?)
  end

  def closing?
    self.status_was == STATUS_OPEN && self.closed?
  end

  #--------------------

  def publish_ticket_to_redis
    text_status = self.status == STATUS_OPEN ? "Opened" : "Closed"
    $redis.publish "scpr-tickets", "** Ticket #{text_status}: \"#{self.summary}\" (#{self.user.name}) (http://scpr.org#{self.admin_show_path})"
  end
  
  #--------------------
  # Validations
  validates :user, :status, :summary, presence: true

  #--------------------
  # Sphinx  
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
