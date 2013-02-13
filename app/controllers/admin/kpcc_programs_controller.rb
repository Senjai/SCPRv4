class Admin::KpccProgramsController < Admin::ResourceController
  #---------------
  # Outpost
  self.model = KpccProgram

  define_list do
    list_default_order "title"
    list_default_sort_mode "asc"
    list_per_page :all
    
    column :title, sortable: true, default_sort_mode: "asc"
    column :air_status
    column :airtime
    column :host

    filter :air_status, collection: -> { KpccProgram::AIR_STATUS }
  end
end
