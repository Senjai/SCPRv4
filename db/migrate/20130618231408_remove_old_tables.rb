class RemoveOldTables < ActiveRecord::Migration
  def up
    [
      :ascertainment_ascertainmentrecord,
      :auth_group,
      :auth_group_permissions,
      :auth_message,
      :auth_permission,
      :auth_user_groups,
      :auth_user_user_permissions,

      :blogs_blogcategory,
      :blogs_entryblogcategory,
      :blogs_entrycategories,

      :contentbase_contentcategory,
      :contentbase_videoshell,

      :django_admin_log,
      :django_content_type,
      :django_session,

      :south_migrationhistory
    ].each do |t| 
      begin
        drop_table t 
      rescue => e
        puts "error on #{t}: #{e}"
        next
      end
    end
  end

  def down
    #lol
  end
end
