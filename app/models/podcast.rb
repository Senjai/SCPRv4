class Podcast < ActiveRecord::Base
  self.table_name = "podcasts_podcast"
  
  belongs_to :program, :class_name => "KpccProgram"
  belongs_to :category
  
  scope :listed, where(:is_listed => true)
end
