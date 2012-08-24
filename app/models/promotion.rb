class Promotion < ActiveRecord::Base
  #-------------
  # Administration
  administrate
  self.list_fields = [
    ["id"],
    ["title", link: true],
  ]

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
