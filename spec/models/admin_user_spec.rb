require "spec_helper"

describe AdminUser do
  describe "associations" do
    it { should have_many(:activities).class_name("Secretary::Version") }
    it { should have_one(:bio) }
  end
  
  #------------------------
  
  describe "scopes" do
    describe "active" do
      it "only returns active users" do
        inactive = create :admin_user, is_active: false
        active   = create :admin_user, is_active: true
        AdminUser.active.should eq [active]
      end
    end
  end
end
