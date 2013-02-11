class Admin::FeaturedCommentsController < Admin::ResourceController
  #----------------
  # Outpost
  self.model = FeaturedComment

  define_list do
    column :bucket
    column :content
    column :username
    column :excerpt
    column :status
    column :published_at
  end
end
