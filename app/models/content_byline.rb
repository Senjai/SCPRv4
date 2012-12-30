class ContentByline < ActiveRecord::Base 
  self.table_name =  "contentbase_contentbyline"
  
  ROLE_EXTRA        = -1
  ROLE_PRIMARY      = 0
  ROLE_SECONDARY    = 1
  ROLE_CONTRIBUTING = 2

  ROLE_TEXT = {
      ROLE_PRIMARY      => "Primary",
      ROLE_SECONDARY    => "Secondary",
      ROLE_CONTRIBUTING => "Contributing",
      ROLE_EXTRA        => "Extra"
  }
  
  ROLE_MAP = {
    :primary      => ROLE_PRIMARY,
    :secondary    => ROLE_SECONDARY,
    :contributing => ROLE_CONTRIBUTING,
    :extra        => ROLE_EXTRA
  }
  
  map_content_type_for_django
  belongs_to :content, polymorphic: true
  belongs_to :user, class_name: "Bio"
    
  define_index do
    indexes user.name, as: :name
    has role
    has user_id
    has content_id
    has content.published_at, as: :published_at,  type: :datetime
    has content.status,       as: :status,        type: :integer
  end

  #-----------------------
  
  class << self
    #-----------------------
    # Takes a hash of bylines and concatenates them intelligently
    # It is assumed that the strings passed-in will be:
    def digest(elements)
      primary   = elements[:primary]
      secondary = elements[:secondary]
      extra     = elements[:extra]
      
      names = [primary, secondary].reject { |e| e.blank? }.join(" with ")
      [names, extra].reject { |e| e.blank? }.join(" | ")
    end
  end

  #-----------------------
  
  def display_name
    @display_name ||= (self.user.try(:name) || self.name)
  end
end
