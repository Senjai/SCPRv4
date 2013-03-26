class AddStatusToEvent < ActiveRecord::Migration
  def change
    add_column :events, :status, :integer
    add_index :events, :status

    Event.all.each do |event|
      status = event.is_published? ? 5 : 0
      event.update_attribute(:status, status)
    end

    remove_column :events, :is_published
  end
end
