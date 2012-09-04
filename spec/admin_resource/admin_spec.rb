require "admin_resource/spec_helper"

describe AdminResource::Admin do
  describe "attributes" do
    subject { AdminResource::Admin.new(BlogEntry) }
    it { should respond_to :list }
    it { should respond_to :model }
  end
  
  it "sets @list to a new List::Base object" do
    admin = AdminResource::Admin.new(BlogEntry)
    admin.list.should be_a AdminResource::List::Base
  end
  
  it "sets @model to whichever model is passed in" do
    admin = AdminResource::Admin.new(BlogEntry)
    admin.model.should eq BlogEntry
  end
  
  describe "define_list" do
    it "yields with the list object" do
      admin = AdminResource::Admin.new(BlogEntry)
      admin.define_list { |list| list }.should eq admin.list
    end
  end
end
