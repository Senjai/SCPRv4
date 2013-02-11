class Admin::VideoShellsController < Admin::ResourceController
  #---------------
  # Outpost
  self.model = VideoShell

  define_list do
    column :headline
    column :slug
    column :byline
    column :published_at
    column :status
  end
end
