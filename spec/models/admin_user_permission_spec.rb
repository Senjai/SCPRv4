require "spec_helper"

describe AdminUserPermission do
  describe "associations" do
    it { should belong_to(:admin_user) }
    it { should belong_to(:permission) }
  end
end
