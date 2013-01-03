class Ticket < ActiveRecord::Base
  STATUS_OPEN   = 1
  STATUS_CLOSED = 0
  
  STATUS_TEXT = {
    STATUS_OPEN   => "Open",
    STATUS_CLOSED => "Closed"
  }

  #--------------------
  # Scopes
  scope :open,   -> { where(status: STATUS_OPEN) }
  scope :closed, -> { where(status: STATUS_CLOSED) }
  
  #--------------------
  # Association  
  belongs_to :user, class_name: "AdminUser"
  
  #--------------------
  # Callbacks
  before_save :set_default_status, if: -> { self.status.blank? }
    
  def set_default_status
    self.status = STATUS_OPEN
  end  
  
  #--------------------
  # Validations
  validates :user, presence: true
  validates :summary, presence: true
  
  #--------------------
  # Administration
  administrate do
    define_list do
      column :user
      column :summary
      column :created_at
      column :status, display: :display_ticket_status
      
      filter :status, collection: -> { Ticket.status_text_collection }
      filter :user, collection: -> { AdminUser.select_collection }
    end
  end
  
  
  #--------------------
  # Sphinx
  acts_as_searchable
  
  define_index do
    indexes summary
    indexes description
    indexes browser_info
  end
  
  #--------------------
  
  attr_accessor :user_name # just for the form
  
  class << self
    def status_text_collection
      STATUS_TEXT.map { |k, v| [v, k] }
    end
  end
end