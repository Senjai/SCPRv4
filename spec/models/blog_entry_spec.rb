require 'spec_helper'

describe BlogEntry do
  describe "validations" do
    it_behaves_like "slug validation"
    it_behaves_like "content validation"
    it_behaves_like "slug unique for date validation" do
      let(:scope) { :published_at }
    end
  end

  # ----------------
  
  describe "callbacks" do
    it_behaves_like "set published at callback"
  end
  
  # ----------------
  
  describe "scopes" do
    it_behaves_like "since scope"
  end
  
  # ----------------
  
  describe "associations" do
    it_behaves_like "content alarm association"
    it_behaves_like "asset association"
    it_behaves_like "audio association"
    
    it { should belong_to :blog }
    it { should have_many :tagged }
    it { should have_many(:tags).through(:tagged).dependent(:destroy) }
    it { should have_many(:blog_entry_blog_categories) }
    it { should have_many(:blog_categories).through(:blog_entry_blog_categories).dependent(:destroy) }
    
    it "deletes tags in the join model when it's deleted" do
      entry = create :blog_entry, tag_count: 1
      TaggedContent.count.should eq 1
      entry.destroy
      TaggedContent.count.should eq 0
    end
    
    it "doesn't delete the tag when the entry is deleted" do
      entry = create :blog_entry, tag_count: 1
      Tag.count.should eq 1
      entry.destroy
      Tag.count.should eq 1
    end
    
    it "deletes categories in the join model when it's deleted" do
      entry = create :blog_entry, blog_category_count: 1
      BlogEntryBlogCategory.count.should eq 1
      entry.destroy
      BlogEntryBlogCategory.count.should eq 0
    end
    
    it "doesn't delete the category when the entry is deleted" do
      entry = create :blog_entry, blog_category_count: 1
      BlogCategory.count.should eq 1
      entry.destroy
      BlogCategory.count.should eq 1
    end
  end
  
  # ----------------
  
  it_behaves_like "status methods"
  it_behaves_like "publishing methods"

  # ----------------
  
  describe "extended_teaser" do
    let(:entry) { create :blog_entry }
    
    it "returns a string" do
      entry.extended_teaser.should be_a String
    end
    
    it "includes paragraphs until the the target length is exceeded" do
      entry.body = "<p>Something</p><p>Something Else</p>"
      extended_teaser = entry.extended_teaser(2)
      extended_teaser.should match /^<p>Something/
      extended_teaser.should_not match /Something Else<\/p>$/
    end
    
    it "breaks if the class is story-break" do
      entry.body = "<p>Blah blah blah</p><br class='story-break' /><p>More Blah</p>"
      entry.extended_teaser.should_not match /More Blah/
    end
    
    it "appends a link to read more at the end, using the passed-in text" do
      entry.body = "<p>Something</p><p>Something Else</p>"
      extended_teaser = entry.extended_teaser(2, "Continue...")
      extended_teaser.should match "Continue..."
      extended_teaser.should match entry.link_path
    end
    
    it "ignores HTML tags when calculating the text length" do
      entry.body = "<p><a href='http://whatever.com'>Blah Blah Blah</a></p><p><strong>Bold Bold Bold</strong></p>"
      extended_teaser = entry.extended_teaser(20)
      extended_teaser.should match /Blah Blah Blah/
      extended_teaser.should match /Bold Bold Bold/
    end
  end
end
