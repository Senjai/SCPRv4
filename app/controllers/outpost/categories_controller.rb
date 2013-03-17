class Outpost::CategoriesController < Outpost::ResourceController
  #-------------
  # Outpost
  self.model = Category

  define_list do
    list_default_order "title"
    list_default_sort_mode "asc"
    list_per_page :all
    
    column :title, sortable: true
    column :slug, sortable: true
    column :is_news
    column :comment_bucket

    filter :is_news, title: "News?", collection: :boolean
  end
end
