module AdminResource
  module Administrate
    attr_accessor :admin

    # Use this to define a block of admin configuration for a model
    # The block variable is an Admin object    
    def administrate
      self.admin = Admin.new(self)
      yield admin if block_given?
    end
    
    ::ActiveRecord::Base.send :extend, self
  end
end
