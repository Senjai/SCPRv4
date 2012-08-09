require 'spec_helper'

describe VideoShell do
  describe "#published" do
    it "orders published content by published_at descending" do
      video_shells = create_list :video_shell, 3, status: 5
      VideoShell.published.to_sql.should match /published_at desc/
    end
  end
  
  #--------------------
  
  describe "scopes" do
    it "#published only selects published content" do
      published = create_list :video_shell, 3, status: 5
      unpublished = create_list :video_shell, 2, status: 3
      VideoShell.published.count.should eq 3
    end
  
    it "#published orders by published_at descending" do
      VideoShell.published.to_sql.should match /published_at desc/i
    end
  end

  # ----------------

  describe "has_format?" do
    it "is true" do
      create(:video_shell).has_format?.should be_false
    end
  end

  # ----------------
  
  describe "auto_published_at" do
    it "is true" do
      create(:video_shell).auto_published_at.should be_true
    end
  end
    
  #--------------------

  describe "teaser" do
    it "is the body" do
      video = build :video_shell
      video.body.should eq video.teaser
    end
  end
  
  #--------------------
  
  describe "link_path" do
    it "does not override the hard-coded options" do
      video_shell = create :video_shell
      video_shell.link_path(trailing_slash: false).should match /\/$/
    end
  end
end
