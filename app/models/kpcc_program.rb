class KpccProgram < ActiveRecord::Base
  self.table_name =  'programs_kpccprogram'
  
  Featured = [
    'madeleine-brand',
    'patt-morrison',
    'offramp',
    'airtalk'
  ]
  
  has_many :episodes, :foreign_key => "show_id", :class_name => "ShowEpisode"
  has_many :schedules, :foreign_key => "kpcc_program_id", :class_name => "Schedule"
  
  def to_param
    slug
  end
  
  # Validation for later
  # validates :slug, uniqueness: true
end