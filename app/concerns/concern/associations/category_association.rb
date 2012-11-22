##
# BylinesAssociation
#
# Defines bylines association
# 
module Concern
  module Associations
    module CategoryAssociation
      extend ActiveSupport::Concern
      
      included do
        has_one :content_category, as: :content
        has_one :category, through: :content_category
      end
    end # CategoryAssociation
  end # Associations
end # Concern
