class ChangeColumnNamesForRailsContentMap < ActiveRecord::Migration
  def change
    rename_column "rails_content_map", "id", "django_content_type_id"
    rename_column "rails_content_map", "class_name", "rails_class_name"
  end
end
