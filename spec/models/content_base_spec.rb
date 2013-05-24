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

  describe '::generate_teaser' do
    it "return a blank string if text is empty" do
      ContentBase.generate_teaser(nil).should eq ''
    end

    it "returns the full first paragraph if it's short enough" do
      first = "This is just a short paragraph."
      teaser = ContentBase.generate_teaser("#{first}\n And some more!")
      teaser.should eq first
    end
    
    it "creates teaser from long paragraph if not defined" do
      long_body = load_fixture("long_text.txt")
      long_body.should match /\n/
      teaser = ContentBase.generate_teaser(long_body)
      teaser.should match /\ALorem ipsum (.+)\.\z/
      teaser.should_not match /\n/
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
      let(:article) { create :news_story }

      before :each do
        stub_const("ContentBase::CONTENT_MATCHES", {  %r{\A/news/(\d+)/.*} => 'NewsStory' } )
        @url = "http://something.com/news/#{article.id}/somethingelse/"
      end
      
      it "sends to obj_by_key if the URI matches" do
        Outpost.should_receive(:obj_by_key).with("news/story:123").and_return("news story")
        ContentBase.obj_by_url(@url).should eq "news story"
      end
  
      it "returns nil if the URI doesn't match" do
        ContentBase.obj_by_url("http://nope.com/wrong").should eq nil
      end

      it 'returns nil if the article is not published' do
        article.update_attribute(:status, ContentBase::STATUS_DRAFT)
        ContentBase.should_receive(:obj_by_key).with(article.obj_key).and_return(article)
        ContentBase.obj_by_url(@url).should eq nil
      end
    end
  end
end
