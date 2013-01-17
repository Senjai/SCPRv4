class Promotion < ActiveRecord::Base
  has_secretary
  
  #-------------
  # Validations
  validates_presence_of :title, :url
  
  #-------------
  # Administration
  administrate do
    define_list do
      column :id
      column :title
    end
  end
  
  #-------------
  # Sphinx
  define_index do
    indexes title
    indexes url
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
