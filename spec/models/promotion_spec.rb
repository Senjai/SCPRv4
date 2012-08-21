require "spec_helper"

describe Promotion do
  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:url) }
  end
end
