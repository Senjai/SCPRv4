class CreateEditions < ActiveRecord::Migration
  def change
    create_table :editions do |t|
      t.integer :status
      t.datetime :published_at
      t.timestamps
    end

    add_index :editions, [:status, :published_at]
  end
end
