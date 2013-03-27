require 'spec_helper'

describe Concern::Associations::ContentAssociation do
  describe '#content_json' do
    it "uses simple_json for the join model" do
      post  = create :test_class_post
      story = create :test_class_story
      content = post.content.build(content: story, position: 0)
      post.save!

      post.content_json.should eq [content.simple_json].to_json
      post.content.should eq [content]
    end
  end

  #------------------

  describe '#content_json=' do
    let(:post)   { create :test_class_post }
    let(:story1) { create :test_class_story }
    let(:story2) { create :test_class_story }
    
    before :each do
      ContentBase.should_receive(:obj_by_key).with(story1.obj_key).and_return(story1)
      ContentBase.should_receive(:obj_by_key).with(story2.obj_key).and_return(story2)
    end
    
    it "adds them ordered by position" do
      post.content_json = "[{ \"id\": \"#{story2.obj_key}\", \"position\": 1 }, {\"id\": \"#{story1.obj_key}\", \"position\": 0 }]"
      post.content.map(&:content).should eq [story1, story2]
    end
    
    it "doesn't add unpublished content" do
      unpublished = create :test_class_story, status: ContentBase::STATUS_DRAFT
      ContentBase.should_receive(:obj_by_key).with(unpublished.obj_key).and_return(unpublished)
      post.content_json = "[{ \"id\": \"#{unpublished.obj_key}\", \"position\": 1 }, {\"id\": \"#{story1.obj_key}\", \"position\": 2 }, {\"id\": \"#{story2.obj_key}\", \"position\": 3 }]"
      post.content.map(&:content).should eq [story1, story2]
    end

    it "parses the json and sets the content" do
      post.content.should be_empty
      post.content_json = "[{\"id\": \"#{story1.obj_key}\", \"position\": 0 }, { \"id\": \"#{story2.obj_key}\", \"position\": 1 }]"
      post.content.map(&:content).should eq [story1, story2]
    end
    
    it 'does not do anything if json is an empty string' do
      post.content.should be_empty
      post.content_json = "[{\"id\": \"#{story1.obj_key}\", \"position\": 0 }, { \"id\": \"#{story2.obj_key}\", \"position\": 1 }]"
      post.content.should be_present
      
      post.content_json = ""
      post.content.should be_present
      
      post.content_json = "[]"
      post.content.should be_empty
    end
  end
end
