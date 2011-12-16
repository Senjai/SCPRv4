class Schedule < ActiveRecord::Base
  set_table_name 'schedule_program'

  belongs_to :kpcc_program, :class_name => "KpccProgram", :polymorphic => true
  belongs_to :other_program, :class_name => "OtherProgram", :polymorphic => true
  
  def programme
    self.kpcc_program || self.other_program
  end
  
end