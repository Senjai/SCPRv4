class Related < ActiveRecord::Base
  self.table_name =  'rails_media_related'
  
  belongs_to :content, :polymorphic => true
  belongs_to :related, :polymorphic => true
  
  FLAG_NORMAL = 0
  FLAG_TIEIN = 1
  FLAG_UPDATE = 2
  
  FLAG_TEXT = {
      FLAG_NORMAL: "Normal",
      FLAG_TIEIN: "Tie-in",
      FLAG_UPDATE: "Update"
  }

  scope :tiein, where(:flag => FLAG_TIEIN)
  scope :updates, where(:flag => FLAG_UPDATE)
  scope :normal, where(:flag => FLAG_NORMAL)
  scope :notiein, where("flag != ?",FLAG_TIEIN)
  
  def self.sorted
    all().sort_by { |r| r.content.public_datetime }
  end
end