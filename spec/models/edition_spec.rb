require 'spec_helper'

describe Edition do
  describe '#abstracts' do
    it 'turns all of the items into abstracts' do
      edition   = create :edition, :published
      story     = create :news_story
      slot      = create :edition_slot, edition: edition, item: story

      edition.abstracts.map(&:class).uniq.should eq [Abstract]
    end
  end

  describe '#articles' do
    it 'turns all of the items into articles' do
      edition   = create :edition, :published
      story     = create :news_story
      slot      = create :edition_slot, edition: edition, item: story

      edition.articles.map(&:class).uniq.should eq [Article]
    end
  end
end
