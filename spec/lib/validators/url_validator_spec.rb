require 'spec_helper'

describe UrlValidator do
  it "doesn't allow invalid URI's" do
    story = build :test_class_remote_story, remote_url: "www.whatever.com"
    story.should_not be_valid
    story.errors.keys.should include :remote_url
  end

  it "allows valid uri's" do
    story = build :test_class_remote_story, remote_url: "http://www.whatever.com"
    story.valid?
    $stdout.puts story.errors.messages
    story.should be_valid
  end
end
