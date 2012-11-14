require File.expand_path("../../spec_helper", __FILE__)

describe AdminResource::Admin do
  describe "attributes" do
    subject { AdminResource::Admin.new(AdminResource::Test::Person) }
    it { should respond_to :list }
    it { should respond_to :model }
  end
  
  it "sets @list to a new List::Base object" do
    admin = AdminResource::Admin.new(AdminResource::Test::Person)
    admin.list.should be_a AdminResource::List::Base
  end
  
  it "sets @model to whichever model is passed in" do
    admin = AdminResource::Admin.new(AdminResource::Test::Person)
    admin.model.should eq AdminResource::Test::Person
  end
  
  describe "::define_list" do
    it "yields with the list object" do
      admin = AdminResource::Admin.new(AdminResource::Test::Person)
      admin.define_list { admin.list }.should eq admin.list
    end
  end
end
