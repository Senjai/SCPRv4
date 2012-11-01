class Promotion < ActiveRecord::Base
  has_secretary
  
  #-------------
  # Administration
  administrate do
    define_list do      
      column :id
      column :title
    end
  end
  
  #-------------
  # Validations
  validates_presence_of :title, :url
  
  #-------------
  
  def asset
    if self.asset_id.present?
      @asset ||= Asset.find(self.asset_id)
    else
      false
    end
  end
end
