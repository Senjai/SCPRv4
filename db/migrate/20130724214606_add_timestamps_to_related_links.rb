class AddTimestampsToRelatedLinks < ActiveRecord::Migration
  def change
    change_table :related_links do |t|
      t.timestamps
    end

    RelatedLink.update_all(created_at: Time.now, updated_at: Time.now)
  end
end
