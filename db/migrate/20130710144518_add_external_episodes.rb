class AddExternalEpisodes < ActiveRecord::Migration
  def change
    create_table :external_episodes do |t|
      t.string :title
      t.integer :external_program_id
      t.string :source
      t.datetime :air_date
      t.timestamps

      t.index :source
      t.index :external_program_id
      t.index :air_date
    end
  end
end
