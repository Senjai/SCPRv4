class Outpost::KpccProgramsController < Outpost::ResourceController
  outpost_controller
  #---------------
  # Outpost
  self.model = KpccProgram

  define_list do |l|
    l.default_order = "title"
    l.default_sort_mode = "asc"
    
    l.column :title, sortable: true, default_sort_mode: "asc"
    l.column :air_status
    l.column :airtime
    l.column :host

    l.filter :air_status, collection: -> { KpccProgram::AIR_STATUS }
  end
end
