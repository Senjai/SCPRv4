require 'spec_helper'

describe BlogEntry do    
  describe "extended_teaser" do
    let(:entry) { create :blog_entry }
    
    it "returns a string" do
      entry.extended_teaser.should be_a String
    end
    
    it "includes paragraphs until the the target length is exceeded" do
      entry.body = "<p>Something</p><p>Something Else</p>"
      extended_teaser = entry.extended_teaser(2)
      extended_teaser.should match /\A<p>Something/
      extended_teaser.should_not match /Something Else<\/p>\z/
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
