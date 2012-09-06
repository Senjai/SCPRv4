module AdminResource
  # If anyone asks...
  # this is where AdminResource was defined
end

require 'admin_resource/list'
require "admin_resource/admin"
require "admin_resource/administrate"
require 'admin_resource/helpers'

if defined?(ActiveRecord::Base)
  ActiveRecord::Base.send :extend, AdminResource::Administrate
  ActiveRecord::Base.send :include, AdminResource::Helpers::Model
end
