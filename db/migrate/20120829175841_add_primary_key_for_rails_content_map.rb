class AddPrimaryKeyForRailsContentMap < ActiveRecord::Migration
  def up
    execute("alter table rails_content_map add primary key (django_content_type_id)")
  end

  def down
    execute("alter table rails_content_map drop primary key")
  end
end
