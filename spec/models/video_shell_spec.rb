require 'spec_helper'

describe VideoShell do
  describe "#published" do
    it "orders published content by published_at descending" do
      video_shells = create_list :video_shell, 3, status: 5
      VideoShell.published.to_sql.should match /published_at desc/
    end
  end
  
  describe "scopes" do
    it "#published only selects published content" do
      published = create_list :video_shell, 3, status: 5
      unpublished = create_list :video_shell, 2, status: 3
      VideoShell.published.count.should eq 3
    end
  
    it "#published orders by published_at descending" do
      video_shells = 3.times { |n| create :video_shell, status: 5, published_at: Time.now + 60*n }
      VideoShell.published.first.should eq VideoShell.where(status: ContentBase::STATUS_LIVE).order("published_at desc").first
    end
  end
  
  describe "link_path" do
    it "does not override the hard-coded options" do
      video_shell = create :video_shell
      video_shell.link_path(trailing_slash: false).should match /\/$/
    end
  end
end