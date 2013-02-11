class Admin::DataPointsController < Admin::ResourceController
  #----------------
  # Outpost
  self.model = DataPoint

  define_list do
    list_order "group_name, data_key"
    list_per_page :all
    
    column :group_name
    column :data_key
    column :data_value, quick_edit: true
    column :notes
    column :updated_at
  end
end
