class Link < ActiveRecord::Base
  self.table_name =  'rails_media_link'
  self.primary_key = "id"
  
  belongs_to :content, :polymorphic => true
  
  default_scope where("content_type != 'ShowSeries'")
  
  #----------
  
  def domain
    if !self.link
      return nil
    end
    
    return domain = URI.parse(URI.encode(self.link)).host
  end
end