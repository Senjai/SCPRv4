class OtherProgram < ActiveRecord::Base
  self.table_name =  'programs_otherprogram'  
  
  has_many :schedules, :foreign_key => "other_program_id", :class_name => "Schedule"
  
  def display_segments
    false
  end
end