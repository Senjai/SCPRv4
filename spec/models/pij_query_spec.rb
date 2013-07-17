require "spec_helper"

describe PijQuery do
  describe '#pending?' do
    it 'checks if the status is pending' do
      query = build :pij_query, status: PijQuery::STATUS_PENDING
      query.pending?.should eq true
    end
  end

  describe '#published?' do
    it 'checks if the status is live' do
      query = build :pij_query, status: PijQuery::STATUS_LIVE
      query.published?.should eq true
    end
  end

  describe '#to_article' do
    it 'builds an article out of a pij query' do
      query = build :pij_query
      query.to_article.should be_a Article
    end
  end
end
