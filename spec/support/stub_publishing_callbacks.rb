##
# StubPublishingCallbacks
# Stub the `publishing?` method so that we can explicitly set published_at dates
# This is more succinct than stubbing published_at 100 times
#
module StubPublishingCallbacks
  def stub_publishing_callbacks(*klasses, &block)
    options = klasses.extract_options!
    val     = !!options[:with]
    
    if klasses.empty?
      # Warning: Does the test environment eager-load models?
      klasses = ActiveRecord::Base.descendants
    end
    
    if block_given?
      context "with stubbed publishing callbacks" do      
        stub_classes(klasses, val)
        yield block
      end
    else
      stub_classes(klasses, val)
    end
  end

  private
    def stub_classes(klasses, val)
      klasses.each do |klass|
        klass.any_instance.stub(:publishing?) { val }
      end
    end
  #
end
