class KpccProgram < ActiveRecord::Base
  set_table_name 'programs_kpccprogram'  
  
  has_many :episodes, :foreign_key => "show_id", :class_name => "ShowEpisode"
end