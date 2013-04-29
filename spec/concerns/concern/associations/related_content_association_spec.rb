require "spec_helper"

describe Concern::Associations::RelatedContentAssociation do
  describe "destroying or unpublishing" do
    before :each do
      @post     = create :test_class_post, status: ContentBase::STATUS_LIVE
      @story    = create :test_class_story, status: ContentBase::STATUS_LIVE
      @related  = create :related_content, content: @post, related: @story

      @related.content.should eq @post
      @related.related.should eq @story

      @post.outgoing_references(true).should eq [@related]
      @story.incoming_references(true).should eq [@related]
    end

    it "destroys the incoming references on destroy" do
      @post.destroy
      @story.incoming_references(true).should eq []
    end

    it "destroys the incoming references on unpublish" do
      @story.status = ContentBase::STATUS_PENDING
      @story.save!

      @story.incoming_references(true).should eq []
    end

    it "doesn't destroy the incoming associations on normal save" do
      @story.headline = "Updated"
      @story.save!

      @story.incoming_references(true).should eq [@related]
    end

    it "doesn't destroy outgoing references on unpublish" do
      @post.status = ContentBase::STATUS_PENDING
      @post.save!

      @post.outgoing_references(true).should eq [@related]
    end
  end

  describe "#related_content" do
    before :each do
      @object  = build :test_class_story
      @shell   = build :test_class_post, published_at: 2.days.ago
      @segment = build :test_class_remote_story, published_at: 1.day.ago
      @story   = build :test_class_story, published_at: 3.days.ago
      @post    = build :test_class_post, status: ContentBase::STATUS_DRAFT

      @object.outgoing_references.build(related: @shell)
      @object.outgoing_references.build(related: @story)
      @object.incoming_references.build(content: @segment)
      @object.outgoing_references.build(content: @post)
    end
    
    it "doesn't return unpublished content" do
      @object.related_content.should_not include @post
    end

    it "Returns all the related records and sorted by published_at desc" do
      @object.related_content.should eq [@segment, @shell, @story]
    end

    it "doesn't return duplicate content" do
      @object.outgoing_references.build(related: @shell)
      @object.incoming_references.build(content: @segment)

      @object.related_content.size.should eq 3
    end
  end

  #---------------------------

  describe '#related_content_json' do
    it "uses simple_json for the join model" do
      story1  = create :test_class_story
      story2  = create :test_class_story
      related = Related.create(content: story1, related: story2, position: 0)

      story1.related_content_json.should eq [related.simple_json].to_json
      story1.outgoing_references.map(&:related).should eq [story2]
    end
  end

  #---------------------------

  describe '#related_content_json=' do
    let(:post)   { create :test_class_post }
    let(:story1) { create :test_class_story }
    let(:story2) { create :test_class_story }
    
    context "when content has changed" do
      before :each do
        Outpost.should_receive(:obj_by_key).with(story1.obj_key).and_return(story1)
        Outpost.should_receive(:obj_by_key).with(story2.obj_key).and_return(story2)
      end
      
      it 'does not do anything if json is an empty string' do
        post.outgoing_references.should be_empty
        post.related_content_json = "[{\"id\": \"#{story1.obj_key}\", \"position\": 0 }, { \"id\": \"#{story2.obj_key}\", \"position\": 1 }]"
        post.outgoing_references.should be_present
        
        post.related_content_json = ""
        post.outgoing_references.should be_present
        
        post.related_content_json = "[]"
        post.outgoing_references.should be_empty
      end
      
      it "parses the json and sets the content" do
        post.outgoing_references.should be_empty
        post.related_content_json = "[{\"id\": \"#{story1.obj_key}\", \"position\": 0 }, { \"id\": \"#{story2.obj_key}\", \"position\": 1 }]"
        post.outgoing_references.map(&:related).should eq [story1, story2]
      end
      
      it "doesn't add unpublished content" do
        unpublished = create :test_class_story, status: ContentBase::STATUS_DRAFT
        Outpost.should_receive(:obj_by_key).with(unpublished.obj_key).and_return(unpublished)

        post.related_content_json = "[{ \"id\": \"#{unpublished.obj_key}\", \"position\": 1 }, {\"id\": \"#{story1.obj_key}\", \"position\": 2 }, {\"id\": \"#{story2.obj_key}\", \"position\": 3 }]"
        post.outgoing_references.map(&:related).should eq [story1, story2]
      end

      it "adds them ordered by position" do
        post.related_content_json = "[{ \"id\": \"#{story2.obj_key}\", \"position\": 1 }, {\"id\": \"#{story1.obj_key}\", \"position\": 0 }]"
        post.outgoing_references.map(&:related).should eq [story1, story2]
      end
      
      it "rollsback properly in a transaction/rollback" do
        post.outgoing_references.size.should eq 0
        
        post.transaction do
          post.related_content_json = "[{\"id\": \"#{story1.obj_key}\", \"position\": 0 }, { \"id\": \"#{story2.obj_key}\", \"position\": 1 }]"
          post.outgoing_references.size.should eq 2
          raise ActiveRecord::Rollback
        end
        
        post.reload
        post.outgoing_references.size.should eq 0
      end
    end

    context "when no content has changed" do
      it "doesn't set the content" do
        original_json = "[{ \"id\": \"#{story2.obj_key}\", \"position\": 1 }]"
        record = create :test_class_story, related_content_json: original_json

        record.should_not_receive :outgoing_references=
        record.related_content_json = original_json
      end
    end
  end
end
