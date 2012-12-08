class AddPartnersToNewsStories < ActiveRecord::Migration
  def up    
    add_column :news_story, :partner, :string
  end

  def down
    remove_column :news_story, :partner
  end
end

