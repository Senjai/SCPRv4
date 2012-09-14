##
# StubPublishingCallbacks
# Stub the `publishing?` method so that we can explicitly set published_at dates
# This is more succinct than stubbing published_at 100 times
#
module StubPublishingCallbacks
  def stub_publishing_callbacks(*klasses)
    if klasses.empty?
      # Warning: Does the test environment eager-load models?
      klasses = ActiveRecord::Base.descendants
    end
      
    klasses.each do |klass|
      klass.any_instance.stub(:publishing?) { false }
    end    
  end
  
  private
    def classes_to_stub
    end
  #
end
