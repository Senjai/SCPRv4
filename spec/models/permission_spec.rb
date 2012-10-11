require "spec_helper"

describe Permission do
  describe "associations" do
    it { should belong_to(:admin_user) }
  end
end
