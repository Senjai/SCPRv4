require "spec_helper"

describe ContentShell do
  it_behaves_like "managed resource" do
    let(:valid_record) { build :content_shell, :published }
    let(:updated_record) { build :content_shell, :published }
    let(:invalid_record) { build :content_shell, status: ContentBase::STATUS_LIVE, headline: "" }
  end

  it_behaves_like "versioned model" do
    let(:valid_record) { build :content_shell, :published }
    let(:updated_record) { build :content_shell, :published }
  end
end
