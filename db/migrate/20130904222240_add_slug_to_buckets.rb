class AddSlugToBuckets < ActiveRecord::Migration
  def change
    add_column :contentbase_misseditbucket, :slug, :string

    MissedItBucket.all.each do |bucket|
      bucket.update_column(:slug, bucket.title.parameterize)
    end
  end
end
