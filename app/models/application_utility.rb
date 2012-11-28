# TODO Get rid of this, it's only a temporary way
# to get around the fact that we need some of the
# helper methods in several parts of the app.
module ApplicationUtility
  extend self
  
  extend ApplicationHelper
  extend WidgetsHelper
end
