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

  describe '::status_select_collection' do
    it 'is an array of status texts' do
      Edition.status_select_collection.first[1].should eq Edition::STATUS_DRAFT
    end
  end

  describe '#published?' do
    it 'is true if status is published' do
      edition = build :edition, :published
      edition.published?.should eq true
    end

    it 'is false if status is not published' do
      edition = build :edition, :pending
      edition.published?.should eq false
    end
  end

  describe '#pending?' do
    it 'is true if status is pending' do
      edition = build :edition, :pending
      edition.pending?.should eq true
    end

    it 'is false if status is not pending' do
      edition = build :edition, :published
      edition.pending?.should eq false
    end
  end

  describe '#status_text' do
    it 'is the human-friendly status' do
      edition = build :edition, :published
      edition.status_text.should be_present
    end
  end

  describe '#publish' do
    it 'sets the status to published' do
      edition = create :edition, :pending
      edition.published?.should eq false
      edition.publish

      edition.reload.published?.should eq true
    end
  end
end
