require "spec_helper"

describe ContentShell do
  let(:valid_record) { build :content_shell, :published }
  let(:updated_record) { build :content_shell, :published }
  let(:invalid_record) { build :content_shell, status: ContentBase::STATUS_LIVE, headline: "" }
  
  it_behaves_like "managed resource"
  it_behaves_like "save options"
  it_behaves_like "admin routes"
  it_behaves_like "versioned model"
end
