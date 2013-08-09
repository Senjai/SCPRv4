class CleanupBiosTable < ActiveRecord::Migration
  def up
    remove_index :bios_bio, :name => "user_id_refs_id_1277bd7cd84326f2"
    change_column :bios_bio, :slug, :string
    change_column :bios_bio, :bio, :text
  end

  def down
  end
end
