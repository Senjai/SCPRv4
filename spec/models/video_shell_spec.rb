require 'spec_helper'

describe VideoShell do  
  describe "validations" do
    it_behaves_like "slug validation"
    it_behaves_like "slug unique validation"
    it_behaves_like "content validation"
    it_behaves_like "published at validation"
  end
  
  #--------------------
  
  describe "scopes" do
    it_behaves_like "since scope"
    
    it "#published only selects published content" do
      published   = create_list :video_shell, 3, :published
      unpublished = create_list :video_shell, 2, :draft
      VideoShell.published.sort.should eq published.sort
    end
  
    it "#published orders by published_at descending" do
      VideoShell.published.to_sql.should match /order by published_at desc/i
    end
  end

  # ----------------

  describe "associations" do
    it_behaves_like "content alarm association"
    it_behaves_like "asset association"
  end
  
  # ----------------
  
  describe "callbacks" do
    #
  end
  
  # ----------------

  it_behaves_like "status methods"
  it_behaves_like "publishing methods"
  
  describe "#has_format?" do
    it "is false" do
      create(:video_shell).has_format?.should be_false
    end
  end

  #--------------------

  describe "#teaser" do
    it "is the body" do
      video = build :video_shell
      video.body.should eq video.teaser
    end
  end
end
