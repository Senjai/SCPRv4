class AddContentShellToCMap < ActiveRecord::Migration
  def up
    execute("insert into rails_content_map(id,class_name) values(115,'ContentShell')")
  end
  
  def down
    execute("delete from rails_content_map where id = 115")
  end
end
