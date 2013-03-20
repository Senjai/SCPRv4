require 'spec_helper'

describe UrlValidator do
  it "requires a protocol" do
    story = build :test_class_remote_story, remote_url: "www.whatever.com"
    story.should_not be_valid
    story.errors.keys.should include :remote_url
  end

  it "handles a URI Error gracefully" do
    story = build :test_class_remote_story, remote_url: '######'
    story.should_not be_valid
    story.errors.keys.should include :remote_url
  end

  it "allows URIs with HTTP protocol" do
    story = build :test_class_remote_story, remote_url: "http://www.whatever.com"
    story.should be_valid
  end

  it "allows HTTPS protocol" do
    story = build :test_class_remote_story, remote_url: "https://www.whatever.com"
    story.should be_valid
  end

  it "allows FTP protocol" do
    story = build :test_class_remote_story, remote_url: "ftp://www.whatever.com"
    story.should be_valid
  end
end
