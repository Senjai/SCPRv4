require 'spec_helper'

describe ExternalSegment do
  describe '#to_article' do
    it "turns it into an article" do
      segment = build :external_segment
      segment.to_article.should be_a Article
    end
  end
end
