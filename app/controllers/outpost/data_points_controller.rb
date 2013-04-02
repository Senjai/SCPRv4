class Outpost::DataPointsController < Outpost::ResourceController
  outpost_controller
  #----------------
  # Outpost
  self.model = DataPoint

  define_list do |l|
    l.default_order = "group_name"
    l.default_sort_mode = "asc"
    l.per_page = :all
    
    l.column :group_name, header: "Group"
    l.column :title
    l.column :data_key, header: "Key", sortable: true, default_sort_mode: "asc"
    l.column :data_value, header: "Value", quick_edit: true
    l.column :notes
    l.column :updated_at, header: "Last Updated", sortable: true, default_sort_mode: "desc"

    l.filter :group_name, collection: -> { DataPoint.group_names_select_collection }
  end
end
