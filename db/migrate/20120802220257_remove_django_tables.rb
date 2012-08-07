class RemoveDjangoTables < ActiveRecord::Migration
  def up
    drop_table "django_comments"
    drop_table "django_comment_flags"
    drop_table "django_comments_backup"
    drop_table "django_site"
    drop_table "flatpages_flatpage_sites"
    drop_table "tickets_ticket"
  end

  def down
  end
end
