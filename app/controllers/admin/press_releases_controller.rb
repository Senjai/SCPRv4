class Admin::PressReleasesController < Admin::ResourceController
  #---------------
  # Outpost
  self.model = PressRelease

  define_list do
    column :short_title
    column :created_at
  end
end
