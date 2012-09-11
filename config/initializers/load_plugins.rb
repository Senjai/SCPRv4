require 'django_helpers'
#require 'multi_american/lib/multi_american'
require 'acts_as_content'
require 'logs_as_task'
require 'admin_resource'

require 'secretary/config'
Secretary::Config.user_class = "::AdminUser"
require 'secretary'
