class Outpost::CategoriesController < Outpost::ResourceController
  outpost_controller
  #-------------
  # Outpost
  self.model = Category

  define_list do |l|
    l.default_order = "title"
    l.default_sort_mode = "asc"
    
    l.column :title, sortable: true
    l.column :slug, sortable: true
    l.column :is_news
    l.column :comment_bucket

    l.filter :is_news, title: "News?", collection: :boolean
  end
end
