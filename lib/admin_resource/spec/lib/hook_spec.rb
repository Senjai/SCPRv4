require File.expand_path("../../spec_helper", __FILE__)

describe AdminResource::Hook do
  before :each do
    @hook = AdminResource::Hook.new(action: "finished", user: "bricker")
  end
  
  describe "#publish" do
    it "posts to the uri with the data" do
      FakeWeb.register_uri(:post, %r|#{Rails.application.config.node.server}|, status: ["200", "OK"])
      @hook.publish
    end
  end
end
