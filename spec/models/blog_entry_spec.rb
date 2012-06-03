require 'spec_helper'

describe BlogEntry do
  it "responds to category" do
    entry = create_list :blog_entry, 3, with_category: true
    entry.any? { |e| e.category == nil }.should be_false
  end
  
  describe "associations" do
    it { should belong_to :blog }
    it { should belong_to :author }
    it { should have_many :tagged }
    it { should have_many(:tags).through(:tagged) }
  end
  
  describe "scopes" do
    describe "#published" do    
      it "orders published content by published_at descending" do
        entries = create_list :blog_entry, 3, status: 5
        BlogEntry.published.first.should eq entries.last
        BlogEntry.published.last.should eq entries.first
      end
    end
  end
  
  describe "link_path" do
    it "does not override hard-coded options" do
      entry = create :blog_entry
      entry.link_path(slug: "wrong").should_not match "wrong"
    end
  end
  
  describe "headline" do
    it "is the title" do
      entry = build :blog_entry
      entry.headline.should eq entry.title
    end
  end
end