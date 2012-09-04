module AdminResource
  module Administrate
    def administrate
      yield admin
    end
  
    def admin
      @admin ||= Admin.new(self)
    end
  end
end
