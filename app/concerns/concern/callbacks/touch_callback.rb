##
# TouchCallback
# 
# For a record to be updated whenever its before_save
# is called.
#
module Concern
  module Callbacks
    module TouchCallback
      extend ActiveSupport::Concern
      
      included do
        after_save -> { self.touch }
      end
    end
  end
end
