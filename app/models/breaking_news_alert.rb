class BreakingNewsAlert < ActiveRecord::Base
  self.table_name = 'layout_breakingnewsalert'
  has_secretary
  
  ALERT_TYPES = {
    "break"   => "Breaking News",
    "audio"   => "Listen Live",
    "now"     => "Happening Now"
  }
  
  #-------------------
  # Scopes
  scope :published, -> { order("created_at desc").where(is_published: true) }
  scope :visible,   -> { where(visible: true) }
  
  #-------------------
  # Associations
  
  #-------------------
  # Validations
  
  #-------------------
  # Callbacks
  
  #-------------------
  # Administration
  administrate do
    define_list do
      list_order "created_at desc"
      column :headline
      column :alert_type, display: proc { BreakingNewsAlert::ALERT_TYPES[self.alert_type] }
      column :visible
      column :is_published
      column :email_sent
    end
  end
  
  #-------------------
  # Sphinx
  define_index do
    indexes headline
    indexes alert_type
    indexes teaser
  end
  
  #-------------------
  
  class << self
    def latest_alert
      alert = self.order("created_at desc").first
      if alert.present? and alert.is_published and alert.visible
        alert
      else
        nil
      end
    end
  end
  
  #-------------------
  
  def break_type
    ALERT_TYPES[alert_type]
  end
  
  #-------------------

  def email_subject
    @email_subject ||= "#{break_type}: #{headline}"
  end  
end
