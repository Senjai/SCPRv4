require 'spec_helper'

describe ContentBase do
  describe "::search" do
    context "sphinx is running" do
      sphinx_spec(num: 1, options: { status: ContentBase::STATUS_LIVE })
    
      it "searches across ContentBase classes" do
        ts_retry(2) do
          ContentBase.search.to_a.should eq @generated_content.sort_by(&:published_at).reverse
        end
      end
    end
    
    context "sphinx is not running" do
      it "has a graceful fallback if sphinx isn't working" do
        %w{ ThinkingSphinx::SphinxError Riddle::ConnectionError }.each do |error|
          ThinkingSphinx.should_receive(:search).and_raise(error.constantize)
          content = ContentBase.search
          content.should be_empty
          content.should respond_to :total_pages
          content.should respond_to :current_page
        end
      end
    end
  end
  
  #---------------
  
  describe "::get_model_for_obj_key" do
    it "accepts nil" do
      ContentBase.get_model_for_obj_key(nil).should eq nil
    end
    
    it "returns nil if key doesn't match anything" do
      ContentBase.get_model_for_obj_key("doesnt/match:123").should eq nil
    end
    
    it "returns the model constant if it does match" do
      Outpost.config.stub(:registered_models) { ["NewsStory"] }
      ContentBase.get_model_for_obj_key("news/story:123").should eq NewsStory
    end
  end
  
  #---------------
  
  describe "::obj_by_key" do
    context "no match" do
      it "returns nil" do
          ContentBase.obj_by_key("nomatch").should eq nil
      end
      
      it "accepts nil argument" do
        ContentBase.obj_by_key(nil).should eq nil
      end
    end
    
    context "match" do
      it "is nil if no record exists" do
        ContentBase.obj_by_key("blogs/entry:9999999").should eq nil
      end
    
      it "finds and returns the record if everything matches" do
        blog_entry = create :blog_entry
        ContentBase.obj_by_key(blog_entry.obj_key).should eq blog_entry
      end
    end
  end

  #---------------
  
  describe "::obj_by_key!" do
    it "raises an error if no object is found" do
      -> { ContentBase.obj_by_key!("something") }.should raise_error ActiveRecord::RecordNotFound
    end
  end
  
  #---------------
  
  describe "::obj_by_url" do
    context "invalid URI" do
      it "returns nil" do
        ContentBase.obj_by_url("$$$$").should eq nil
      end
    end
    
    context "valid URI" do
      before :each do
        stub_const("ContentBase::CONTENT_MATCHES", {  %r{\A/news/(\d+)/.*} => 'NewsStory' } )
        @url = "http://something.com/news/123/somethingelse/"
      end
      
      it "sends to obj_by_key if the URI matches" do
        ContentBase.should_receive(:obj_by_key).with("news/story:123").and_return("news story")
        ContentBase.obj_by_url(@url).should eq "news story"
      end
  
      it "returns nil if the URI doesn't match" do
        ContentBase.obj_by_url("http://nope.com/wrong").should eq nil
      end
    end
  end
end
