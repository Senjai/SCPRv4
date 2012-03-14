class Link < ActiveRecord::Base
  self.table_name =  'rails_media_link'
  
  belongs_to :content, :polymorphic => true
  
  #----------
  
  def domain
    if !self.link
      return nil
    end
    
    return domain = URI.parse(self.link).host
  end
end