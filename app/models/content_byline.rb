class ContentByline < ActiveRecord::Base
  set_table_name "rails_contentbase_contentbyline"
  
  ROLE_PRIMARY = 0
  ROLE_SECONDARY = 1
  ROLE_CONTRIBUTING = 2
  
  ROLE_TEXT = {
      ROLE_PRIMARY: "Primary",
      ROLE_SECONDARY: "Secondary",
      ROLE_CONTRIBUTING: "Contributing"
  }
  
  scope :primary, where(:role => ROLE_PRIMARY)
  
  belongs_to :content, :polymorphic => true
  belongs_to :user, :class_name => "Bio"
  
end