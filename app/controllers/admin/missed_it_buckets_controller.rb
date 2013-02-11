class Admin::MissedItBucketsController < Admin::ResourceController
  #-----------------
  # Outpost
  self.model = MissedItBucket

  define_list do
    column :id
    column :title
  end
end
