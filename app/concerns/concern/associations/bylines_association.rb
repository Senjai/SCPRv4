##
# BylinesAssociation
#
# Defines bylines association
# 
module Concern
  module Associations
    module BylinesAssociation
      extend ActiveSupport::Concern
      
      included do
        has_many :bylines, as: :content, class_name: "ContentByline",  dependent: :destroy
      end
      
      #-------------------
      
      def byline_elements
        ["KPCC"]
      end

      #-------------------
      # Returns a hash of bylines grouped by ROLE
      # @story.grouped_bylines[:primary]
      def grouped_bylines
        @grouped_bylines ||= begin
          {
            :primary      => bylines_by_role(:primary),
            :secondary    => bylines_by_role(:secondary),
            :contributing => bylines_by_role(:contributing),
            :extra        => self.byline_elements.reject { |b| b.blank? }
          }
        end
      end

      #-------------------
      
      private
      
      #-------------------
      # Get the record's bylines, filtered by role.
      # This is to prevent multiple database queries.
      # Pass in one or more roles as a symbol. See
      # ContentByline::ROLE_MAP for possible arguments.
      def bylines_by_role(*roles)
        role_ids = roles.map { |role| ContentByline::ROLE_MAP(role) }
        self.bylines.select { |b| role_ids.include? b.role  }
      end
    end # BylinesAssociation
  end # Associations
end # Concern
