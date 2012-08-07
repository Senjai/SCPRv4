require "spec_helper"

describe PijQuery do
  it { should respond_to :link_path }
  it { should respond_to :remote_link_path }
  it { should respond_to :headline }
  it { should respond_to :assets }
  
  #---------------
  
  describe "validations" do
    it "validates uniqueness" do
      create :pij_query
      should validate_uniqueness_of :slug
    end
    
    it { should validate_presence_of :slug }
    it { should validate_presence_of :query_type }
    it { should validate_presence_of :query_url }
    it { should validate_presence_of :query_type }
  end
  
  #---------------
  
  describe "scopes" do
    describe "evergreen" do
      it "only selects evergreen" do
        evergreen = create :pij_query, :evergreen, :visible
        news      = create :pij_query, :news, :visible
        PijQuery.evergreen.all.should eq [evergreen]
      end
    end

    #---------------
    
    describe "news" do
      it "only selects news" do
        evergreen = create :pij_query, :evergreen, :visible
        news      = create :pij_query, :news, :visible
        PijQuery.news.all.should eq [news]
      end
    end
  end
  
  #---------------
  
  describe "link_path" do
    it "has the slug" do
      pij_query = create :pij_query
      pij_query.link_path.should match pij_query.slug
    end
  end
  
  #---------------
  
  describe "remote_link_path" do
    it "has the domain" do
      create(:pij_query).remote_link_path.should match /scpr\.org/
    end
  end
  
  #---------------
  
  describe "visible" do
    it "doesn't select inactive" do
      create :pij_query, :inactive
      PijQuery.visible.should be_blank
    end
    
    it "doesn't select unpublished" do
      create :pij_query, :unpublished
      PijQuery.visible.should be_blank
    end
    
    it "doesn't select expired" do
      create :pij_query, :expired
      PijQuery.visible.should be_blank
    end
    
    it "selects anything which meets all 3 criteria" do
      active_query = create :pij_query, :visible
      PijQuery.visible.should eq [active_query]
    end
  end
end