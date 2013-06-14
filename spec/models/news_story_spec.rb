require 'spec_helper'

describe NewsStory do
  describe '#to_article' do
    it 'makes a new article' do
      story = build :news_story
      story.to_article.should be_a Article
    end
  end

  describe '#to_abstract' do
    it 'makes a new abstract' do
      story = build :news_story
      story.to_abstract.should be_a Abstract
    end
  end
end
