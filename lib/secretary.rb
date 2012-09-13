require "secretary/config"

module Secretary
  extend ActiveSupport::Autoload
  
  class << self
    attr_writer :config
    def config
      @config || Secretary::Config.configure
    end
    
    def versioned_models
      @versioned_models ||= []
    end
  end
    
  autoload :Error
  autoload :HasSecretary
  autoload :Version
  autoload :Diff
end

ActiveSupport.on_load(:active_record) do
  extend Secretary::HasSecretary
end
