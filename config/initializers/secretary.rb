# Configuration for Secretary
require_dependency "secretary"

Secretary::Config.configure do |config|
  config.user_class = "::AdminUser"
end

# Administration for Versions
module Secretary
  class Version
    administrate do
      define_list do
        column :user, display: proc { self.user.try(:to_title) || "System" }
        column :description
        column :versioned, header: "Object", display: proc { self.versioned.simple_title }
        column :version_number, header: "Version"
        column :created_at, header: "Timestamp"
      end
    end
  end
end
