require "spec_helper"

describe Category do
  describe "validations" do
    it_behaves_like "slug validation"
  end
  
  #--------------------
  
  describe "associations" do
    it { should belong_to :comment_bucket }
  end

  #--------------------
  
  describe "link_path" do
    it "can generate a link_path" do
      category = create :category_news
      Scprv4::Application.reload_routes!
      category.should respond_to :link_path
      category.link_path.should_not be_nil
    end
    
    it "accepts an options hash" do
      category = create :category_news
      Scprv4::Application.reload_routes!
      lambda { category.link_path(anchor: "comments") }.should_not raise_error
    end
    
    it "merges in an options hash unless it's a ContentShell" do
      category = create :category_news
      Scprv4::Application.reload_routes!
      category.link_path(anchor: "comments").should match "#comments"
    end
    
    it "does not override hard-coded options" do
      category = create :category_news
      category2 = create :category_news
      Scprv4::Application.reload_routes!
      category.link_path(id: category2.id).should_not match Category.find(category2.id).slug
    end
  end

  #--------------------
  
  describe "content" do
    it "returns an empty array if the page * per_page is greater than Thinking Sphinx's max_matches" do
      category = create :category_news
      category.content(101, 10).should be_blank
    end
  end

  #--------------------
  
  describe "featured_candidates" do
    pending
  end
end
