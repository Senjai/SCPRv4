require "spec_helper"

describe NewsStory do
  it_behaves_like "managed resource" do
    let(:valid_record) { build :news_story, :published }
    let(:updated_record) { build :news_story, :published }
    let(:invalid_record) { build :news_story, status: ContentBase::STATUS_LIVE, headline: "" }
  end

  it_behaves_like "versioned model" do
    let(:valid_record) { build :news_story, :published }
    let(:updated_record) { build :news_story, :published }
  end
end
