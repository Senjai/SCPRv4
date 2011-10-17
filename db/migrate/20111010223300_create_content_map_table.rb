class CreateContentMapTable < ActiveRecord::Migration
  def up
    create_table(:rails_content_map, :id => false) do |t|
      t.integer :id, :null => false, :unique => true
      t.string :class_name, :null => false, :unique => true
    end
    
    execute("insert into rails_content_map values(15,'NewsStory')")
    execute("insert into rails_content_map values(25,'ShowEpisode')")
    execute("insert into rails_content_map values(24,'ShowSegment')")
    execute("insert into rails_content_map values(51,'ShowSeries')")
    execute("insert into rails_content_map values(44,'BlogEntry')")
  end

  def down
    drop_table :rails_content_map
  end
end
