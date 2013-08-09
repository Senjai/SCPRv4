require 'spec_helper'

describe Concern::Callbacks::TouchCallback do
  it 'always updates the updated_at timestamp on save' do
    story = build :test_class_story
    story.save!

    timestamp = story.updated_at
    sleep 2
    story.save!

    story.updated_at.should be > timestamp
  end
end
