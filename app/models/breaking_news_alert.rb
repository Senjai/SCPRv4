class BreakingNewsAlert < ActiveRecord::Base
  self.table_name = 'layout_breakingnewsalert'
  
  def break_type
    if alert_type = "break"
      "Breaking News"
    elsif alert_type = "audio"
      "Listen Live"
    elsif alert_type = "now"
      "Happening Now"
    end  
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