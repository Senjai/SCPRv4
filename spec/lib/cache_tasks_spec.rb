require "spec_helper"

describe CacheTasks::Task do
  describe "#cache" do
    it "Writes the rendered content into cache" do
      task = CacheTasks::Task.new
      ActionView::Base.any_instance.should_receive(:render).with(partial: "some/cool/partial", object: "some cool object", as: :content) { "The Cache" }
      Rails.cache.fetch("some:cool:key").should eq nil
      task.cache("some cool object", "some/cool/partial", "some:cool:key").should eq true
      Rails.cache.fetch("some:cool:key").should eq "The Cache"
    end
  end
end
