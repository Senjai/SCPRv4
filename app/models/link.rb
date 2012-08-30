class Link < ActiveRecord::Base
  self.table_name   = 'media_link'
  self.primary_key = "id"

  default_scope where("content_type is not null")

  map_content_type_for_django  
  belongs_to :content, polymorphic: true
    
  #----------
  
  def domain
    if !self.link
      return nil
    end
    
    return domain = URI.parse(URI.encode(self.link)).host
  end
end
