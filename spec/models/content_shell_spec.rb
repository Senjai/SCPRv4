require 'spec_helper'

describe ContentShell do
  describe "remote_link_path" do
    it "uses the url attribute" do
      shell = build :content_shell
      shell.remote_link_path.should eq shell.url
    end
  end
  
  describe "link_path" do
    it "uses the url attribute" do
      shell = build :content_shell
      shell.link_path.should eq shell.url
    end
  end
end