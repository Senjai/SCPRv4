require 'spec_helper'

describe BlogEntry do
  it "responds to category" do
    @entry = create_list :blog_entry, 3
    @entry.any? { |e| e.category == nil }.should be_false
  end
  
  describe "scopes" do
    it "#published only selects published content" do
      @published = create_list :blog_entry, 3, status: 5
      @unpublished = create_list :blog_entry, 2, status: 3
      BlogEntry.published.count.should eq 3
    end
  end
  
  describe "instance" do # TODO: Move these into ContentBase specs
    it "inherits from ContentBase" do
      @entry = build :blog_entry
      @entry.should be_a ContentBase
    end
    
    it "returns a link_path" do
      @entry = create :blog_entry
      @entry.link_path.should eq Rails.application.routes.url_helpers.blog_entry_path(
        :blog => @entry.blog.slug,
        :year => @entry.published_at.year, 
        :month => @entry.published_at.month.to_s.sub(/^[^0]$/) { |n| "0#{n}" }, 
        :day => @entry.published_at.day.to_s.sub(/^[^0]$/) { |n| "0#{n}" },
        :id => @entry.id,
        :slug => @entry.slug,
        :trailing_slash => true
      ) # This should be hardcoded in
    end
      
    describe "#short_headline" do
      it "returns short_headline if defined" do
        short_headline = "Short"
        @entry = build :blog_entry, _short_headline: short_headline
        @entry.short_headline.should eq short_headline
      end
    
      it "returns headline if not defined" do
        @entry = build :blog_entry
        @entry.short_headline.should eq @entry.headline
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