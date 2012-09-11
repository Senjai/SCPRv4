module Secretary
  # okay
end

require "secretary/config"
require "secretary/has_secretary"
require "secretary/version"
require "secretary/diff"

ActiveSupport.on_load(:active_record) do
  include Secretary::HasSecretary
end

ActiveRecord::Base.has_secretary
