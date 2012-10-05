require "spec_helper"

describe ShowEpisode do
  let(:valid_record) { build :show_episode, :published }
  let(:updated_record) { build :show_episode, :published }
  let(:invalid_record) { build :show_episode, status: ContentBase::STATUS_LIVE, body: "" }
  
  it_behaves_like "managed resource"
  it_behaves_like "versioned model"
  it_behaves_like "front-end routes request"
end
