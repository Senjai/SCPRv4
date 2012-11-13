## 
# AdminResource::Administrate

module AdminResource
  module Administrate
    attr_accessor :admin

    # Use this to define a block of admin configuration for a model
    # The block variable is an Admin object
    def administrate(&block)
      include AdminResource::Model
      
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
      begin
        default_fields = self.column_names - AdminResource.config.excluded_list_columns
        default_fields.each do |field|
          self.admin.list.column field
        end
      # If the table doesn't exist, just rescue so as not to halt db rake tasks
      # TODO: Come up with a better solution
      rescue
        Rails.logger.warn "AdminResource: set_default_columns caught an exception"
        []
      end
    end
    
    #-------------------
    
    def set_default_fields
      begin
        self.admin.fields = self.column_names - AdminResource.config.excluded_form_fields
      # If the table doesn't exist, just rescue so as not to halt db rake tasks
      # TODO: Come up with a better solution
      rescue
        Rails.logger.warn "AdminResource: set_default_fields caught an exception"
        []
      end
    end
  end # Administrate
end # AdminResource
