class AddEventToContentMap < ActiveRecord::Migration
  def change
    execute("insert into rails_content_map(id,class_name) values(88,'Event')")
  end
end
