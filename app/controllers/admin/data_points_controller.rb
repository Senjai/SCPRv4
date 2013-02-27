class Admin::DataPointsController < Admin::ResourceController
  #----------------
  # Outpost
  self.model = DataPoint

  define_list do
    list_default_order "group_name"
    list_default_sort_mode "asc"
    list_per_page :all
    
    column :group_name, header: "Group"
    column :data_key, header: "Key", sortable: true, default_sort_mode: "asc"
    column :data_value, header: "Value", quick_edit: true
    column :notes
    column :updated_at, header: "Last Updated", sortable: true, default_sort_mode: "desc"

    filter :group_name, collection: -> { DataPoint.group_names_select_collection }
  end
end
