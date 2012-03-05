class AddVideoShellToContentTypes < ActiveRecord::Migration
  def up
    execute("insert into rails_content_map(id,class_name) values(125,'VideoShell')")
  end

  def down
    execute("delete from rails_content_map where id=125")
  end
end
