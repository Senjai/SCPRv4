class Outpost::DistinctScheduleSlotsController < Outpost::ResourceController
  outpost_controller

  define_list do |l|
    l.default_order = "starts_at"
    l.default_sort_mode = "desc"
    
    l.column :title
    l.column :starts_at, sortable: true, default_sort_mode: "desc"
    l.column :ends_at
    l.column :info_url, header: "Info", display: :display_link
  end
end
