class CreateTickets < ActiveRecord::Migration
  def change
    create_table "tickets" do |t|
      t.integer :user_id
      t.string :browser_info
      t.string :link
      t.integer :agrees
      t.string :summary
      t.text :description
      t.timestamps
    end
    
    add_index "tickets", :agrees
    add_index "tickets", :user_id
  end
end
