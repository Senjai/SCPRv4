class Admin::OtherProgramsController < Admin::ResourceController
  #--------------------
  # Outpost
  self.model = OtherProgram

  define_list do
    list_default_order "title"
    list_default_sort_mode "asc"
    list_per_page :all
    
    column :title, sortable: true, default_sort_mode: "asc"
    column :airtime
    column :produced_by
    column :air_status

    filter :air_status, collection: -> { KpccProgram::AIR_STATUS }
  end
end
