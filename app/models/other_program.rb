class OtherProgram < ActiveRecord::Base
  set_table_name 'programs_otherprogram'  
  
  has_many :schedules, :foreign_key => "other_program_id", :class_name => "Schedule"
end