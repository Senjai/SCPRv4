##
# AdminResource::List

module AdminResource
  module List
    DEFAULTS = {
      :order    => "id desc",
      :per_page => 25,
    }
  end
end

require "admin_resource/list/base"
require "admin_resource/list/column"
