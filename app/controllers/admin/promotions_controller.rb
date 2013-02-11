class Admin::PromotionsController < Admin::ResourceController
  #---------------
  # Outpost
  self.model = Promotion

  define_list do
    column :id
    column :title
  end
end
