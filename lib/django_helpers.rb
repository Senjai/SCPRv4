module DjangoHelpers
  # okay!
end

require "django_helpers/base"

ActiveRecord::Base.send :extend, DjangoHelpers::Base
