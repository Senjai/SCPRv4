class ContentByline < ActiveRecord::Base
  set_table_name "rails_contentbase_contentbyline"
  
  belongs_to :content, :polymorphic => true
  belongs_to :user, :class_name => "Bio"
end