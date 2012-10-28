require "spec_helper"

describe Permission do
  describe "associations" do
    it { should have_many(:admin_user_permissions) }
    it { should have_many(:admin_users).through(:admin_user_permissions) }
  end
end
