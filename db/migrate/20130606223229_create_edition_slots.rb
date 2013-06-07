class CreateEditionSlots < ActiveRecord::Migration
  def change
    create_table :edition_slots do |t|
      t.string :item_type
      t.integer :item_id
      t.integer :edition_id
      t.integer :position
      t.timestamps
    end

    add_index :edition_slots, :edition_id
    add_index :edition_slots, :position
    add_index :edition_slots, [:item_type, :item_id]
  end
end
