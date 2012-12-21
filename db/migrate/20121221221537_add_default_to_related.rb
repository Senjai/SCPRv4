class AddDefaultToRelated < ActiveRecord::Migration
  def up
    change_column :media_related, :position, :integer, default: 0
  end
  
  def down
  end
  
end
