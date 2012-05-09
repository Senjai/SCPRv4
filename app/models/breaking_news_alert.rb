class BreakingNewsAlert < ActiveRecord::Base
  self.table_name = 'layout_breakingnewsalert'
  
  def self.get_alert
    alert = self.order("created_at desc").first
    if alert.present? and alert.is_published
      alert
    else
      nil
    end
  end
end