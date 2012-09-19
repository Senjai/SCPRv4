require "spec_helper"

describe Section do
  describe "associations" do
    it { should have_many(:section_categories) }
    it { should have_many(:categories).through(:section_categories) }
    it { should have_many(:section_blogs) }
    it { should have_many(:blogs).through(:section_blogs) }
    it { should have_many(:promotions) }
    it { should belong_to(:missed_it_bucket) }
  end
  
  #----------------------
  
  describe "validations" do
    it { should validate_presence_of(:title) }
    it_behaves_like "slug validation"
    it_behaves_like "slug unique validation"
  end

  #----------------------

  describe "#link_path" do
    it "has the slug" do
      section = create :section, slug: "something"
      section.link_path.should match "something"
    end
  end
  
  #----------------------
  
  describe "#content" do
    it "only returns results within the section's category" do
      pending "SPHIINNXXXXXX"
      
      setup_sphinx
      
      politics_category = create :category, category: "Politics"
      music_category    = create :category, category: "Music"
      politics_content  = make_content(2, category: politics_category)
      music_content     = make_content(2, category: music_category)
      section           = create :section, categories: [politics_category]
      
      index_sphinx
            
      @section_content = section.content
      
      politics_content.each do |content|
        @section_content.should include content
      end
      
      music_content.each do |content|
        @section_content.should_not include content
      end
            
      teardown_sphinx
    end
    
    it "sets page to 1 if the max_matches will throw an error" do
      pending
    end
  end
end
