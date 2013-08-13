require "spec_helper"

describe Publisher do
  describe '::publish' do
    it 'sends the data off to redis' do
      story = create :test_class_story

      data = {
        :object => story,
        :action => 'publish'
      }

      $redis.should_receive(:publish)
      Publisher.publish(data)
    end
  end
end
