class Outpost::ExternalProgramsController < Outpost::ResourceController
  outpost_controller

  define_list do |l|
    l.default_order = "title"
    l.default_sort_mode = "asc"

    l.column :title, sortable: true, default_sort_mode: "asc"
    l.column :airtime
    l.column :produced_by
    l.column :air_status

    l.filter :air_status, collection: -> { KpccProgram::AIR_STATUS }
  end
end
