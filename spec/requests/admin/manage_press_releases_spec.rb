require "spec_helper"

describe PressRelease do
  let(:valid_record) { build :press_release }
  let(:updated_record) { build :press_release }
  let(:invalid_record) { build :press_release, short_title: "" }
  
  it_behaves_like "managed resource"
  it_behaves_like "save options"
  it_behaves_like "admin routes"
  it_behaves_like "versioned model"
  it_behaves_like "front-end routes"
end
