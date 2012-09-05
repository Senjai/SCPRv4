require 'admin_resource/list'
require 'admin_resource/list/base'
require 'admin_resource/list/column'

require "admin_resource/title"

require "admin_resource/admin"
require "admin_resource/administrate"
require 'admin_resource/helpers'

class ActiveRecord::Base
  include AdminResource::Title
  extend AdminResource::Administrate
end
