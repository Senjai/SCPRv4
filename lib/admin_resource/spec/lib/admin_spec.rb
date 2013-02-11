require File.expand_path("../../spec_helper", __FILE__)

describe Outpost::Admin do
  describe "attributes" do
    subject { Outpost::Admin.new(Outpost::Test::Person) }
    it { should respond_to :list }
    it { should respond_to :model }
  end
  
  it "sets @list to a new List::Base object" do
    admin = Outpost::Admin.new(Outpost::Test::Person)
    admin.list.should be_a Outpost::List::Base
  end
  
  it "sets @model to whichever model is passed in" do
    admin = Outpost::Admin.new(Outpost::Test::Person)
    admin.model.should eq Outpost::Test::Person
  end
  
  describe "::define_list" do
    it "yields with the list object" do
      admin = Outpost::Admin.new(Outpost::Test::Person)
      admin.define_list { admin.list }.should eq admin.list
    end
  end
end
