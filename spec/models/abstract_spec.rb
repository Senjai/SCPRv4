require 'spec_helper'

describe Abstract do
  describe '#to_abstract' do
    it 'is itself' do
      abstract = create :abstract
      abstract.to_abstract.should equal abstract #abstract
    end
  end

  describe '#to_article' do
    it 'builds a new article' do
      abstract = build :abstract
      abstract.to_article.should be_a Article
    end
  end
end
