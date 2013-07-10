module Concern
  module Associations
    module PolymorphicProgramAssociation
      extend ActiveSupport::Concern

      included do
        belongs_to :program, polymorphic: true
      end


      def program_obj_key
        self.program.try(:obj_key)
      end

      def program_obj_key=(obj_key)
        self.program = Outpost.obj_by_key(obj_key)
      end
    end # PolymorphicProgramAssociation
  end # Associations
end # Concern
