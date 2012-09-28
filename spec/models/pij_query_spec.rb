require "spec_helper"

describe PijQuery do
  it { should respond_to :headline }
  it { should respond_to :short_headline }
  it { should respond_to :body }
  it { should respond_to :teaser }
  it { should respond_to :link_path }
  it { should respond_to :remote_link_path }
  it { should respond_to :obj_key }
  it { should respond_to :auto_published_at }
  it { should respond_to :has_format? }
  
  it { should_not respond_to :disqus_identifier }
  
  #---------------

  describe "associations" do
    it_behaves_like "asset association"
    it_behaves_like "audio association"
  end
  
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
  
  # ----------------

  describe "has_format?" do
    it "is true" do
      create(:pij_query).has_format?.should be_false
    end
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

    #---------------
    
    describe "featured" do
      it "only selects featured queries" do
        featured     = create :pij_query, is_featured: true
        not_featured = create :pij_query, is_featured: false
        PijQuery.featured.should eq [featured]
      end
    end
    
    #---------------
    
    describe "not_featured" do
      it "only selects not featured queries" do
        featured     = create :pij_query, is_featured: true
        not_featured = create :pij_query, is_featured: false
        PijQuery.not_featured.should eq [not_featured]
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
end
