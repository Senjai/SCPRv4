##
# AudioAssociation
#
# Association and callbacks for Audio
#
module Concern
  module Associations
    module AudioAssociation
      extend ActiveSupport::Concern
      
      included do
        has_many :audio, as: :content, order: "position asc"
        accepts_nested_attributes_for :audio, allow_destroy: true, reject_if: :should_reject_audio?
      end
      
      #------------------
      # If all of these attributes are blank, reject it,
      # because obviously they weren't trying to attach
      # any audio.
      #
      # Otherwise, the person was trying to do something
      # and we should handle it, valid or not.
      #
      # Can't use `all_blank?` because `position` has a
      # default value (0).
      def should_reject_audio?(attributes)
        attributes['mp3'].blank? && 
        attributes['enco_number'].blank? && 
        attributes['enco_date'].blank? && 
        attributes['mp3_path'].blank? &&
        attributes['description'].blank? &&
        attributes['byline'].blank?
      end
    end # AudioAssociation
  end # Associations
end # Concern
