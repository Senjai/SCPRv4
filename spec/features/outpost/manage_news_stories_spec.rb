require "spec_helper"

describe NewsStory do
  let(:valid_record) { build :news_story, :published }
  let(:updated_record) { build :news_story, :published }
  let(:invalid_record) { build :news_story, :published, headline: "" }

  it_behaves_like "managed resource"
  it_behaves_like "save options"
  it_behaves_like "admin routes"
  it_behaves_like "versioned model"
  it_behaves_like "front-end routes"
end
