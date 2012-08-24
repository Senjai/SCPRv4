require 'spec_helper'

describe BlogEntry do
  
  describe "validations" do
    it { should validate_presence_of :headline }
    it { should validate_presence_of :slug }  
  end
  
  # ----------------
  
  describe "associations" do
    it { should belong_to :blog }
    it { should belong_to :author }
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
  
  it "responds to category" do
    entry = create_list :blog_entry, 3, with_category: true
    entry.any? { |e| e.category == nil }.should be_false
  end

  # ----------------
  
  describe "scopes" do
    describe "#published" do    
      it "orders published content by published_at descending" do
        BlogEntry.published.to_sql.should match /order by published_at desc/i
      end
    end
  end

  # ----------------

  describe "has_format?" do
    it "is true" do
      create(:blog_entry).has_format?.should be_true
    end
  end

  # ----------------
  
  describe "auto_published_at" do
    it "is true" do
      create(:blog_entry).auto_published_at.should be_true
    end
  end
  
  # ----------------
  
  describe "link_path" do
    it "does not override hard-coded options" do
      entry = create :blog_entry
      entry.link_path(slug: "wrong").should_not match "wrong"
    end
  end
end