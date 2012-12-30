class CreateTickets < ActiveRecord::Migration
  def change
    create_table "tickets" do |t|
      t.integer :user_id
      t.string :browser_info
      t.string :link
      t.string :summary
      t.text :description
      t.integer :agrees
      t.integer :status
      t.timestamps
    end
    
    add_index "tickets", :agrees
    add_index "tickets", :user_id
    add_index "tickets", :status
  end
end
