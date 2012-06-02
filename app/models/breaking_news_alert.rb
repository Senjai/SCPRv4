class BreakingNewsAlert < ActiveRecord::Base
  self.table_name = 'layout_breakingnewsalert'
    
  ALERT_TYPES = {
    "break" => "Breaking News",
    "audio" => "Listen Live",
    "now" => "Happening Now"
  }
  
  def break_type
    ALERT_TYPES[alert_type]
  end
  
  def email_subject
    @email_subject = "#{break_type}: #{headline}"
  end
  
  def self.get_alert
    alert = self.order("created_at desc").first
    if alert.present? and alert.is_published
      alert
    else
      nil
    end
  end
end
