class Admin::CategoriesController < Admin::ResourceController
  #-------------
  # Outpost
  self.model = Category

  define_list do
    list_per_page :all
    
    column :title
    column :slug
    column :is_news
    column :comment_bucket
  end
end
