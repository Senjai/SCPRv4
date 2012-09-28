require "spec_helper"

describe VideoShell do
  let(:valid_record) { build :video_shell, :published }
  let(:updated_record) { build :video_shell, :published }
  let(:invalid_record) { build :video_shell, status: ContentBase::STATUS_LIVE, headline: "" }

  it_behaves_like "managed resource"
  it_behaves_like "versioned model"
  it_behaves_like "front-end routes request"
end
