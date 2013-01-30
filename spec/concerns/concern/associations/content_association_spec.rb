require 'spec_helper'

describe Concern::Associations::ContentAssociation do
  describe '#content_json=' do
    it "parses the json and sets the content" do
      post = create :test_class_post
      story1 = create :test_class_story
      story2 = create :test_class_story
      
      post.content.should be_empty
      
      ContentBase.should_receive(:obj_by_key).with(story1.obj_key).and_return(story1)
      ContentBase.should_receive(:obj_by_key).with(story2.obj_key).and_return(story2)
      
      post.content_json = "[{\"id\": \"#{story1.obj_key}\", \"position\": 0 }, { \"id\": \"#{story2.obj_key}\", \"position\": 1 }]"

      post.content.size.should eq 2
      post.content.first.content.should eq story1
      post.content.last.content.should eq story2
    end
  end
end
