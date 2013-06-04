class Outpost::PressReleasesController < Outpost::ResourceController
  outpost_controller
  
  define_list do |l|
    l.default_order = "created_at"
    l.default_sort_mode = "desc"

    l.column :short_title
    l.column :created_at, sortable: true, default_sort_mode: "desc"
  end
end
