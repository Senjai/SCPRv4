require 'secretary/config'
Secretary::Config.user_class = "::AdminUser"
require 'secretary'

module Secretary
  class Version
    administrate do |admin|
      admin.define_list do |list|
        list.column "user"
        list.column "description", linked: true
        list.column "versioned", header: "Object", helper: Proc.new { |versioned| versioned.simple_title }
        list.column "version_number", header: "Version"
        list.column "created_at", header: "Timestamp"
      end
    end
  end
end
