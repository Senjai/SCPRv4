class Promotion < ActiveRecord::Base
  has_secretary
  ROUTE_KEY = "promotion"
  
  #-------------
  # Administration
  administrate do |admin|
    admin.define_list do |list|      
      list.column "id"
      list.column "title", linked: true
    end
  end
  
  #-------------
  # Validations
  validates_presence_of :title, :url
  
  #-------------

  def route_hash
    return {} if !self.persisted?
    { slug: self.slug }
  end
  
  #-------------
  
  def asset
    if self.asset_id.present?
      @asset ||= Asset.find(self.asset_id)
    else
      false
    end
  end
end
