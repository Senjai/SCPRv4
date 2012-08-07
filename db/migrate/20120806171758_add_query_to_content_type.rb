class AddQueryToContentType < ActiveRecord::Migration
  def change
    execute("insert into rails_content_map(id,class_name) values(75,'PijQuery')")
  end
end
