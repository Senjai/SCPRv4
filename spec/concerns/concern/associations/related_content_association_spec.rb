require "spec_helper"

describe Concern::Associations::RelatedContentAssociation do
  describe "#related_content" do
    before :each do
      @object  = build :news_story
      @shell  = create :content_shell
      @segment = create :show_segment
      
      @object.outgoing_references.build(related: @shell)
      @object.incoming_references.build(content: @segment)
    end
    
    it "Returns all the related records" do
      @object.related_content.should include @shell
      @object.related_content.should include @segment
    end
    
    it "sorts by published_at desc" do
      @shell.update_attribute(:published_at, Time.now)
      @segment.update_attribute(:published_at, Time.now.yesterday)
      
      @object.related_content.first.should eq @shell
      
      @segment.update_attribute(:published_at, Time.now)
      @shell.update_attribute(:published_at, Time.now.yesterday)
      
      @object.related_content.first.should eq @segment
    end
    
    it "doesn't return duplicate content" do
      @object.outgoing_references.build(related: @shell)
      @object.incoming_references.build(content: @segment)

      @object.related_content.size.should eq 2
    end
  end
end
