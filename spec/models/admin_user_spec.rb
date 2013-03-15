require "spec_helper"

describe AdminUser do
  describe "associations" do
    it { should have_many(:activities).class_name("Secretary::Version") }
    it { should have_one(:bio) }
  end
end
