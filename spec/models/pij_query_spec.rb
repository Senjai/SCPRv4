require "spec_helper"

describe PijQuery do
  describe '::status_select_collection' do
    it 'is an array of status texts' do
      PijQuery.status_select_collection.first[1].should eq PijQuery::STATUS_HIDDEN
    end
  end

  describe '#to_article' do
    it 'builds an article out of a pij query' do
      query = build :pij_query
      query.to_article.should be_a Article
    end
  end

  describe '#published?' do
    it 'is true if status is published' do
      pij_query = build :pij_query, :published
      pij_query.published?.should eq true
    end

    it 'is false if status is not published' do
      pij_query = build :pij_query, :pending
      pij_query.published?.should eq false
    end
  end

  describe '#pending?' do
    it 'is true if status is pending' do
      pij_query = build :pij_query, :pending
      pij_query.pending?.should eq true
    end

    it 'is false if status is not pending' do
      pij_query = build :pij_query, :published
      pij_query.pending?.should eq false
    end
  end

  describe '#status_text' do
    it 'is the human-friendly status' do
      pij_query = build :pij_query, :published
      pij_query.status_text.should be_present
    end
  end

  describe '#publish' do
    it 'sets the status to published' do
      pij_query = create :pij_query, :pending
      pij_query.published?.should eq false
      pij_query.publish

      pij_query.reload.published?.should eq true
    end
  end
end
