class HomepageContent < ActiveRecord::Base
  self.table_name =  "rails_layout_homepagecontent"
  
  belongs_to :homepage
  belongs_to :content, :polymorphic => true  
end