##
# Outpost::List

module Outpost
  module List
    DEFAULTS = {
      :order    => "id desc",
      :per_page => 25,
    }
  end
end

require "outpost/list/base"
require "outpost/list/column"
