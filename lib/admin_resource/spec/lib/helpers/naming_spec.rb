require File.expand_path("../../../spec_helper", __FILE__)

describe AdminResource::Helpers::Naming do
  describe "::to_class" do
    it "turns the controller param into its corresponding class" do
      AdminResource::Helpers::Naming.to_class("admin/people").should eq Person
    end
  end
end
