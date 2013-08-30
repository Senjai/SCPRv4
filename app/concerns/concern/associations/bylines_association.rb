##
# BylinesAssociation
#
# Defines bylines association
module Concern
  module Associations
    module BylinesAssociation
      extend ActiveSupport::Concern

      included do
        has_many :bylines,
          :as               => :content,
          :class_name       => "ContentByline",
          :dependent        => :destroy,
          :before_add       => :get_original_bylines,
          :before_remove    => :get_original_bylines

        tracks_association :bylines

        accepts_nested_attributes_for :bylines,
          :allow_destroy    => true,
          :reject_if        => :should_reject_bylines?

        #-------------------
        # Byline Filter
        # Pass it a bio ID
        # It returns records with that bio
        scope :filtered_by_bylines, ->(bio_id) {
          self.includes(:bylines)
          .where(ContentByline.table_name => { user_id: bio_id })
        }


        after_save :promise_to_index_bylines, if: -> { self.changed? }
        after_destroy :promise_to_index_bylines
        after_commit :enqueue_sphinx_index_for_bylines
      end

      #-------------------
      # Returns a nice string of bylines joined together
      def byline
        ContentByline.digest self.joined_bylines
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
      # to just be an array of strings, it will always
      # just be joined and isn't passed into the block.
      #
      # Returns a hash
      def joined_bylines(&block)
        elements = {}

        # Go through each role and either pass that role's bylines
        # to the block, or just map to the display_name
        # Then convert to_sentence and push into elements
        ContentByline::ROLE_MAP.keys.each do |role|
          string = case role
          when :extra
            grouped_bylines[:extra].join(" | ")
          else
            bylines = grouped_bylines[role]
            strings = (block_given? ? yield(bylines) : bylines.map(&:display_name))
            strings.reject { |e| e.blank? }.to_sentence
          end

          elements[role] = string
        end

        elements
      end


      private

      def promise_to_index_bylines
        @_will_index_bylines = true
      end

      def reset_byline_index_promises
        @_will_index_bylines = nil
      end

      def enqueue_sphinx_index_for_bylines
        if @_will_index_bylines
          Indexer.enqueue("ContentByline")
        end

        reset_byline_index_promises
      end

      #-------------------

      def should_reject_bylines?(attributes)
        attributes['user_id'].blank? &&
        attributes['name'].blank?
      end

      #-------------------
      # Get the record's bylines, filtered by role.
      # This is to prevent multiple database queries.
      # Pass in one or more roles as a symbol. See
      # ContentByline::ROLE_MAP for possible arguments.
      def bylines_by_role(role)
        self.bylines.select { |b| b.role == ContentByline::ROLE_MAP[role] }
      end
    end # BylinesAssociation
  end # Associations
end # Concern
