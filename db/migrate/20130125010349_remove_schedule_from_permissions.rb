class RemoveScheduleFromPermissions < ActiveRecord::Migration
  def up
    p = Permission.find_by_resource("Schedule")
    p.destroy if p 
    
    p = Permission.find_by_resource("Tag")
    p.destroy if p
  end
  
  def down
    "sorry bro"
  end
end
