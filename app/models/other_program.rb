class OtherProgram < ActiveRecord::Base
  self.table_name =  'programs_otherprogram'  
  
  has_many :schedules, :foreign_key => "other_program_id", :class_name => "Schedule"
  
  def is_segmented
    false
  end
end