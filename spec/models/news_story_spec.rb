require 'spec_helper'

describe NewsStory do
  describe "associations" do # TODO move this into content_base_spec
    it { should have_many :assets }
    it { should have_many :bylines }
    it { should have_many :brels }
    it { should have_many :frels }
    it { should have_many :related_links }
    it { should have_many :queries }
    it { should have_one :content_category }
    it { should have_one(:category).through(:content_category) }
    it { should belong_to :enco_audio }
    it { should have_many :uploaded_audio }
  end
  
  describe "link_path" do
    it "does not override the hard-coded options" do
      news_story = create :news_story
      news_story.link_path(slug: "wrong").should_not match "wrong"
    end
    
    describe "#published" do
      it "orders published content by published_at descending" do
        stories = create_list :news_story, 3, status: 5
        NewsStory.published.first.should eq stories.last
        NewsStory.published.last.should eq stories.first
      end
    end
  end
end