##
# This just adds a method to the FormBuilder which
# renders a "section" and passes in a few things:
#
# * f (which is the FormBuilder itself)
# * record (the object that the form builder is for)
# * extra (a block containing extra stuff to render)
#
# The section partial has to exist.
#
module ActionView
  module Helpers
    class FormBuilder
      def section(partial, &block)
        @template.render( 
          :partial => "/admin/shared/sections/#{partial}", 
          :locals  => {
            :f      => self,
            :record => self.object, 
            :extra  => block_given? ? @template.capture(&block) : ""
          })
      end
    end
  end
end
