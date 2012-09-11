require "admin_resource/spec_helper"

describe AdminResource::Helpers::Model do
  describe "to_title" do
    it "uses one of the specified title attributes if available" do
      stub_const("AdminResource::Helpers::Model::TITLE_ATTRIBUTES", [:name])
      person = Person.new(name: "Bryan Ricker")
      person.to_title.should eq "Bryan Ricker"
    end
    
    it "falls back to a generic title if none of the attributes match" do
      stub_const("AdminResource::Helpers::Model::TITLE_ATTRIBUTES", [:title])
      person = Person.new(id: 1, name: "Bryan Ricker")
      person.to_title.should eq "Person #1"
    end
  end
end
