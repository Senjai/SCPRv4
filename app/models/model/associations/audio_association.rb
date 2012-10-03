##
# AudioAssociation
#
# Association and callbacks for Audio
#
module Model
  module Associations
    module AudioAssociation
      extend ActiveSupport::Concern
      
      included do
        has_many :audio, as: :content, order: "position asc"
        accepts_nested_attributes_for :audio, allow_destroy: true, reject_if: :should_reject_audio?
                
        #------------------
        
        def should_reject_audio?(attributes)
          attributes['mp3'].blank? && attributes['enco_number'].blank? && attributes['mp3_path'].blank?
        end
      end
    end
  end
end
