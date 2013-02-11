class Admin::KpccProgramsController < Admin::ResourceController
  #---------------
  # Outpost
  self.model = KpccProgram

  define_list do
    list_order "title"
    list_per_page :all
    
    column :title
    column :air_status
  end
end
