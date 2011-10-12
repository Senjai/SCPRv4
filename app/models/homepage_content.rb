class HomepageContent < ActiveRecord::Base
  set_table_name "rails_layout_homepagecontent"
  
  belongs_to :homepage
  belongs_to :content, :polymorphic => true  
end