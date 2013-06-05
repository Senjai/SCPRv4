require "spec_helper"

describe PijQuery do
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
