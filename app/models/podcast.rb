class Podcast < ActiveRecord::Base
  administrate
  self.table_name = "podcasts_podcast"
  has_secretary
  
  belongs_to :program, :class_name => "KpccProgram"
  belongs_to :category
  
  scope :listed, where(:is_listed => true)
end
