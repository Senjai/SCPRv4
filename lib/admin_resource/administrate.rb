## 
# AdminResource::Administrate

module AdminResource
  module Administrate
    attr_accessor :admin

    # Use this to define a block of admin configuration for a model
    # The block variable is an Admin object
    def administrate(&block)
      include AdminResource::Helpers::Model
      include AdminResource::Helpers::Routes
      
      self.admin = Admin.new(self)
      admin.instance_eval(&block) if block_given?
    end
  end
end
