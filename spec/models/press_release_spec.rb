require "spec_helper"

describe PressRelease do
  describe "validations" do
    it_behaves_like "slug validation"
    it { should validate_presence_of(:short_title) }
  end  
end
