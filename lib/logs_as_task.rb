# The point of this is to provide a simple way 
# to log to Rails.logger and STDOUT with just one method.
# It will not log to STDOUT in the test environment.
#
# Usage:
#
#   class Person < ActiveRecord::Base
#     logs_as_task
#   end
#
#   Person.log("Message will appear in STDOUT and Rails log file")
#
module LogsAsTask
  def logs_as_task
    extend ClassMethods
  end
  
  module ClassMethods
    def log(msg)
      Rails.logger.info msg
      Logger.new(STDOUT).info(msg) unless Rails.env == "test"
    end
  end
end

ActiveRecord::Base.extend LogsAsTask
