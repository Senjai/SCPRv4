module Secretary
  # okay
end

require "secretary/config"
require "secretary/error"
require "secretary/has_secretary"
require "secretary/version"
require "secretary/diff"

ActiveSupport.on_load(:active_record) do
  extend Secretary::HasSecretary
end
