##
# Outpost::Controller
#
module Outpost
  module Controller
    extend ActiveSupport::Autoload
    extend ActiveSupport::Concern

    autoload :Actions
    autoload :Callbacks
    autoload :Helpers

    #----------------------

    included do
      helper_method :list, :model, :fields
    end

    #----------------------

    def model
      self.class.model
    end

    #----------------------

    def list
      self.class.list
    end

    def fields
      self.class.fields
    end

    #----------------------
    #----------------------

    module ClassMethods
      attr_accessor :model
      attr_writer :list, :fields

      #----------------------
    
      def fields
        @fields ||= default_fields
      end

      #----------------------
      # Get the List object for this controller.
      #
      # If `list` hasn't yet been defined,
      # then we'll figure out some sensible columns to use.
      # Otherwise use the defined list.
      def list
        @list ||= begin
          List::Base.new model do
            default_columns.each do |column|
              list.column column
            end
          end
        end
      end

      #----------------------
      # Define the list for this controller.
      #
      # Pass a block.
      #
      def define_list(&block)
        @list = List::Base.new(&block)
      end

      #----------------------
      # Declare a controller as being a controller for
      # Outpost.
      #
      # Attributes:
      #
      # * model - (constant) the model for this controller
      #
      # Example:
      #
      #   class Admin::NewsStoriesController < Admin::ResourceController
      #     outpost_controller model: NewsStory
      #   end
      #
      def outpost_controller(attributes={})
        @model = attributes[:model]

        include Outpost::Controller::Actions
        include Outpost::Controller::Helpers
      end
    end # ClassMethods
  end # Controller
end # Outpost
