class PijQuery < ActiveRecord::Base
  self.table_name = 'pij_query'

  administrate
  
  scope :visible, where(
    'is_active = :is_active and published_at < :time and ' \
    '(expires_at is null or expires_at > :time)', 
    is_active: true, time: Time.now
  ).order("published_at desc")
  
  # Hard-code this for now since it's still pointing to mercer
  def remote_link_path
    "http://www.scpr.org/network/questions/#{self.slug}/"
  end
end