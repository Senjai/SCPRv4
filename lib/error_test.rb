##
# ErrorTest
#
# This file's sole purpose is to make stuff fail.
# Useful for testing purposes. See scprv4.rake "test_error"
# for use-case.
#
class ErrorTest
  include NewRelic::Agent::Instrumentation::ControllerInstrumentation

  def test_error
    raise StandardError, "NewRelic Test Exception (This is supposed to fail!)"
  end

  add_transaction_tracer :test_error, category: :task
end

# And a Resque Job
class ErrorTestJob
  @queue = "scprv4"

  def self.perform
    test = ErrorTest.new
    test.test_error
  end
end
