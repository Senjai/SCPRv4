##
# Admin Resource
# Build admin pages with Ruby

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
  autoload :Administrate
  autoload :Helpers
end

if defined?(ActiveRecord::Base)
  ActiveRecord::Base.send :extend, AdminResource::Administrate
end
