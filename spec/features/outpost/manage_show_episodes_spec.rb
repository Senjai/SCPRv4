require "spec_helper"

describe ShowEpisode do
  let(:valid_record) { build :show_episode, :published }
  let(:updated_record) { build :show_episode, :published }
  let(:invalid_record) { build :show_episode, :published, body: "" }

  it_behaves_like "save options"
  it_behaves_like "admin routes"
  it_behaves_like "versioned model"
  it_behaves_like "front-end routes"
end
