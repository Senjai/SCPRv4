##
# Admin Resource
# Build admin pages with Ruby

require 'active_record'
require 'action_controller'

require 'admin_resource/config'

module AdminResource
  extend ActiveSupport::Autoload
  
  class << self
    attr_writer :config
    def config
      @config || AdminResource::Config.configure
    end    
  end
  
  autoload :Error
  autoload :List
  autoload :Admin
  autoload :Model
  autoload :Administrate
  autoload :Helpers
  autoload :Controller
end

if defined?(ActiveRecord::Base)
  ActiveRecord::Base.send :extend, AdminResource::Administrate
end
