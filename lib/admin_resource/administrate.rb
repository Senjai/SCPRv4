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
      self.admin.instance_eval(&block) if block_given?
      
      # Setup default columns if none were given
      if !self.admin.list_defined?
        set_default_columns
      end
      
      if !self.admin.fields_defined?
        set_default_fields
      end
    end

    #-------------------
    
    private
    def set_default_columns
      default_fields = self.column_names - AdminResource.config.excluded_list_columns
      default_fields.each do |field|
        self.admin.list.column field
      end
    end
    
    #-------------------
    
    def set_default_fields
      self.admin.fields = self.column_names - AdminResource.config.excluded_form_fields
    end
  end # Administrate
end # AdminResource
