require 'spec_helper'

describe BlogEntry do
  it "responds to category" do
    entry = create_list :blog_entry, 3
    entry.any? { |e| e.category == nil }.should be_false
  end
  
  describe "associations" do # TODO move this into content_base_spec
    it { should have_many :assets }
    it { should have_many :bylines }
    it { should have_many :brels }
    it { should have_many :frels }
    it { should have_many :related_links }
    it { should have_many :queries }
    it { should have_one :content_category }
    it { should have_one(:category).through(:content_category) }
    it { should belong_to :blog }
    it { should belong_to :author }
    it { should have_many :tagged }
    it { should have_many(:tags).through(:tagged) }
    it { should have_many :uploaded_audio }
  end
  
  describe "scopes" do
    describe "#published" do    
      it "orders published content by published_at (or pub_at) descending" do
        entries = create_list :blog_entry, 3, status: 5
        BlogEntry.published.first.should eq entries.last
        BlogEntry.published.last.should eq entries.first
      end
    end
  end
  
  describe "instance" do # TODO: Move these into ContentBase specs
    describe "link_path" do
      it "returns a link_path" do
        entry = create :blog_entry
        entry.should respond_to(:link_path)
      end
      
      it "does not override the hard-coded options" do
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
    
    describe "#short_headline" do
      it "returns short_headline if defined" do
        short_headline = "Short"
        @entry = build :blog_entry, _short_headline: short_headline
        @entry.short_headline.should eq short_headline
      end
    
      it "returns title if not defined" do
        @entry = build :blog_entry
        @entry.short_headline.should eq @entry.title
      end
    end
    
    describe "#teaser" do
      it "returns teaser if defined" do
        teaser = "This is a short teaser"
        @entry = build :blog_entry, _teaser: teaser
        @entry.teaser.should eq teaser
      end
    
      it "creates teaser from long paragraph if not defined" do
        @entry = build :blog_entry
        @entry.teaser.should eq "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque a enim a leo auctor lobortis. Etiam aliquam metus sit amet nulla blandit molestie. Cras lobortis odio non turpis laoreet..."
      end
      
      it "returns the full first paragraph if it's short enough" do
        short_first_paragraph = "This is just a short paragraph."
        @entry = build :blog_entry, content: "#{short_first_paragraph}\n And some more!"
        @entry.teaser.should eq short_first_paragraph
      end
    end
  end
end