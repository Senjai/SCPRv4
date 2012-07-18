require "spec_helper"

describe PijQuery do  
  describe "visible" do
    it "doesn't select inactive" do
      create :pij_query, 
              is_active: false, 
              published_at: 1.day.ago,
              expires_at: 1.day.from_now
      PijQuery.visible.should be_blank
    end
    
    it "doesn't select unpublished" do
      create :pij_query, 
              is_active: true, 
              published_at: 1.day.from_now,
              expires_at: 2.days.from_now
      PijQuery.visible.should be_blank
    end
    
    it "doesn't select expired" do
      create :pij_query, 
              is_active: true, 
              published_at: 2.days.ago,
              expires_at: 1.day.ago
      PijQuery.visible.should be_blank
    end
    
    it "selects anything which meets all 3 criteria" do
      active_query = create :pij_query, 
              is_active: true, 
              published_at: 1.day.ago,
              expires_at: 1.day.from_now
      PijQuery.visible.should eq [active_query]
    end
  end
end