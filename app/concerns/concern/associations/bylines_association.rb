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
      # Returns a nice string of bylines joined together
      def byline
        ContentByline.digest self.joined_bylines(:primary, :secondary, :extra)
      end
      
      #-------------------
      # Default byline extras
      # This can be overridden
      def byline_extras
        ["KPCC"]
      end

      #-------------------
      # Returns a hash of bylines grouped by ROLE
      def grouped_bylines
        @grouped_bylines ||= begin
          {
            :primary      => bylines_by_role(:primary),
            :secondary    => bylines_by_role(:secondary),
            :contributing => bylines_by_role(:contributing),
            :extra        => self.byline_extras.reject { |b| b.blank? }
          }
        end
      end
      
      #-------------------
      # Join the bylines in each role passed in,
      # turning it into a string
      #
      # If a block is passed, the bylines for each
      # role will be passed into the block
      # Otherwise, it will just use the display_name
      #
      # Note that because the :extra role is assumed
      # to just be an array of stirngs, it will always 
      # just be joined and isn't passed into the block.
      #
      # Returns an array
      def joined_bylines(*roles, &block)
        elements = []
        
        # Go through each role and either pass that role's bylines
        # to the block, or just map to the display_name
        # Then convert to_sentence and push into elements
        roles.each do |role|
          string = case role
          when :extra
            grouped_bylines[:extra].join(" | ")
          else
            bylines = grouped_bylines[role]
            strings = (block_given? ? yield(bylines) : bylines.map(&:display_name))
            strings.reject { |e| e.blank? }.to_sentence
          end
          
          elements.push(string) if string.present?
        end

        elements
      end
      
      #-------------------
      
      private
      
      #-------------------
      # Get the record's bylines, filtered by role.
      # This is to prevent multiple database queries.
      # Pass in one or more roles as a symbol. See
      # ContentByline::ROLE_MAP for possible arguments.
      def bylines_by_role(*roles)
        role_ids = roles.map { |role| ContentByline::ROLE_MAP[role] }
        self.bylines.select { |b| role_ids.include? b.role  }
      end
    end # BylinesAssociation
  end # Associations
end # Concern
