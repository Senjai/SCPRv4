class AddExternalEpisodes < ActiveRecord::Migration
  def change
    create_table :external_episodes do |t|
      t.string :title
      t.text :summary
      t.integer :external_program_id
      t.string :external_id
      t.datetime :air_date
      t.timestamps
    end

    add_index :external_episodes, [:external_program_id, :external_id]
    add_index :external_episodes, :air_date
  end
end
