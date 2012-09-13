# Configuration for Secretary
require_dependency "secretary"

Secretary::Config.configure do |config|
  config.user_class = "::AdminUser"
end

# Administration for Versions
module Secretary
  class Version
    administrate do |admin|      
      admin.define_list do |list|
        list.column "user", helper: ->(user) { user.try(:to_title) || "System" }
        list.column "description", linked: true
        list.column "versioned", header: "Object", helper: ->(versioned) { versioned.simple_title }
        list.column "version_number", header: "Version"
        list.column "created_at", header: "Timestamp"
      end
    end
  end
end
