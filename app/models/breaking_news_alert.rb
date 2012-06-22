class BreakingNewsAlert < ActiveRecord::Base
  self.table_name = 'layout_breakingnewsalert'
    
  ALERT_TYPES = {
    "break" => "Breaking News",
    "audio" => "Listen Live",
    "now" => "Happening Now"
  }
  
  scope :published, order("created_at desc").where(is_published: true)
  scope :visible, where(visible: true)
  
  def break_type
    ALERT_TYPES[alert_type]
  end
  
  def email_subject
    @email_subject = "#{break_type}: #{headline}"
  end
  
  def self.latest_alert
    published.visible.first
  end
end
