require "spec_helper"

describe Permission do
  describe "associations" do
    it { should have_many(:admin_user_permissions) }
    it { should have_many(:admin_users).through(:admin_user_permissions) }
  end

  #----------------

  describe "validations" do
    it { should validate_uniqueness_of(:resource) }
  end
  
  #----------------
  
  describe "#title" do
    it "is the resource, titleized" do
      permission = Permission.new(resource: "SomeCoolThing")
      permission.title.should eq "Some Cool Thing"
    end
  end
end
