##
# Tasker::Task
#
module Tasker
  class Task
  end
end


__END__

Something like this:

A Task should respond to a few methods:

* run: How to actually perform the task. Tasker::Task will be a noop.
* enqueue: How to enqueue the task. Tasker::Task will provide a default for this.

Task classes will go in app/tasks

class HomepageTask < Tasker::Task
  def run
    # blah blah
  end
  
  def enqueue
  end
  
  #...
  
end

The worker will just go through each class in app/tasks and add it to to the loop
Should there be a worker for every task?

module Tasker
  class Worker
  end
end
