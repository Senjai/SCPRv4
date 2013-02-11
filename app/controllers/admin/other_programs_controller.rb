class Admin::OtherProgramsController < Admin::ResourceController
  #--------------------
  # Outpost
  self.model = OtherProgram

  define_list do
    list_order "title"
    list_per_page :all
    
    column :title
    column :produced_by
    column :air_status
  end
end
