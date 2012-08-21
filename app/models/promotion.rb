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
  
end
