class Admin::PressReleasesController < Admin::ResourceController
  #---------------
  # Outpost
  self.model = PressRelease

  define_list do
    list_default_order "created_at"
    list_default_sort_mode "desc"

    column :short_title
    column :created_at, sortable: true, default_sort_mode: "desc"
  end
end
