require "spec_helper"

describe BlogCategory do
  it { should belong_to(:blog) }
  it { should have_many(:blog_entry_blog_categories) }
  it { should have_many(:blog_entries).through(:blog_entry_blog_categories).dependent(:destroy) }
  
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:slug) }

  describe "destroying" do
    before :each do
      @blog_category = create :blog_category
      @entry = create :blog_entry
      create :blog_entry_blog_category, blog_category: @blog_category, blog_entry: @entry
    end
    
    it "deletes links in the join model when it's deleted" do
      BlogEntryBlogCategory.count.should eq 1
      @blog_category.destroy
      BlogEntryBlogCategory.count.should eq 0
    end
  
    it "doesn't delete the entry when the category is deleted" do
      BlogEntry.count.should eq 1
      @blog_category.destroy
      BlogEntry.count.should eq 1
    end
  end
end
