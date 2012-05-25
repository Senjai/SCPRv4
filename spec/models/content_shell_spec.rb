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
  
  describe "#published" do      
    it "orders published content by published_at descending" do
      content_shells = create_list :content_shell, 3, status: 5
      ContentShell.published.first.should eq content_shells.last
      ContentShell.published.last.should eq content_shells.first
    end
  end
end