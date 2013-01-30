require "spec_helper"

describe Section do  
  describe "#content" do
    it "only returns results within the section's category" do
      pending "SPHIINNXXXXXX"
      
      setup_sphinx
      
      politics_category = create :category, title: "Politics"
      music_category    = create :category, title: "Music"
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
