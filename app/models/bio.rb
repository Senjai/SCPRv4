class Bio < ActiveRecord::Base
  set_table_name 'bios_bio'
  
  belongs_to :user
end