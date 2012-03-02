class KpccProgram < ActiveRecord::Base
  self.table_name =  'programs_kpccprogram'  
  
  has_many :episodes, :foreign_key => "show_id", :class_name => "ShowEpisode"
  has_many :schedules, :foreign_key => "kpcc_program_id", :class_name => "Schedule"
  
  has_many :segments, :foreign_key => "show_id", :class_name => "ShowSegment"
end