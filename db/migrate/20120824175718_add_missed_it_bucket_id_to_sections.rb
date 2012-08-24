class AddMissedItBucketIdToSections < ActiveRecord::Migration
  def change
    add_column "sections", "missed_it_bucket_id", :integer
  end
end
