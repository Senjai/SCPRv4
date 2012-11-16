require "spec_helper"

# This is in spec/models so that it gets run as a unit test.
describe CacheController do
  describe "#cache" do
    it "writes to cache" do
      cacher = CacheController.new
      cacher.should_receive(:render).with(partial: "coolpartial", object: "Cool Object", as: :content).and_return("The Partial")
      Rails.cache.fetch("coolkey").should eq nil
      cacher.cache("Cool Object", "coolpartial", "coolkey")
      Rails.cache.fetch("coolkey").should eq "The Partial"
    end
  end
end
