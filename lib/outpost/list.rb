##
# Outpost::List

module Outpost
  module List
    extend ActiveSupport::Autoload

    DEFAULTS = {
      :order    => "id desc",
      :per_page => 25,
    }

    autoload :Base
    autoload :Column
    autoload :Filter
  end
end
