class AddTimestampsToRelatedLinks < ActiveRecord::Migration
  def change
    change_table :related_links do |t|
      t.timestamps
    end

    RelatedLink.find_in_batches do |group|
      group.each do |link|
        link.update_column(:created_at, Time.now)
        link.update_column(:updated_at, Time.now)
      end
    end
  end
end
