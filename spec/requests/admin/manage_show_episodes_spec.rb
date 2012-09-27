require "spec_helper"

describe ShowEpisode do
  it_behaves_like "managed resource" do
    let(:valid_record) { build :show_episode, :published }
    let(:updated_record) { build :show_episode, :published }
    let(:invalid_record) { build :show_episode, status: ContentBase::STATUS_LIVE, headline: "" }
  end
  
  it_behaves_like "versioned model" do
    let(:valid_record) { build :show_episode, :published }
    let(:updated_record) { build :show_episode, :published }
  end
end
