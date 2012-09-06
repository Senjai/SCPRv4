module ActsAsContent
  # okay!
end # ActsAsContent

require "acts_as_content/base"

ActiveRecord::Base.send :extend, ActsAsContent::Base
