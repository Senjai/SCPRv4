require 'admin_resource/class_methods'
require 'admin_resource/instance_methods'
require 'admin_resource/helpers'

module AdminResource
  DEFAULTS = {
    list_order: "id desc",
    list_per_page: 25,
    excluded_fields: ["id", "created_at", "updated_at"]
  }

  TITLE_ATTRIBS = [:name, :short_headline, :title, :headline]
  
  def administrate
    extend ClassMethods
    include InstanceMethods
  end
  
end

ActiveRecord::Base.extend AdminResource
