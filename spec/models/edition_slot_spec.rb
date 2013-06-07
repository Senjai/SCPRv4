require 'spec_helper'

describe EditionSlot do
  describe '#simple_json' do
    it 'includes the obj_key and position' do
      story = create :news_story
      slot  = create :edition_slot, item: story

      json = slot.simple_json
      json["id"].should eq story.obj_key
      json["position"].should eq 0
    end
  end
end
