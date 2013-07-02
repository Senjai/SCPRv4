module Concern
  module Associations
    module PolymorphicProgramAssociation
      extend ActiveSupport::Concern

      included do
        belongs_to :program, polymorphic: true
        before_validation :set_program_from_obj_key
      end


      attr_writer :program_obj_key

      def program_obj_key
        @program_obj_key || self.program.try(:obj_key)
      end


      private

      def set_program_from_obj_key
        self.program = Outpost.obj_by_key(self.program_obj_key)
      end
    end
  end
end
