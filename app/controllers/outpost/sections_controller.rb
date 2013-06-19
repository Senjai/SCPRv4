class Outpost::SectionsController < Outpost::ResourceController
  outpost_controller
  #--------------
  # Outpost
  self.model = Section

  define_list do |l|
    l.default_order = "title"
    l.default_sort_mode = "asc"
    
    l.column :id
    l.column :title
    l.column :slug
  end
end
