require "spec_helper"

describe Admin::ResourceController do
  describe "#get_record" do
    it "returns the record if it exists" do
      record = create :news_story
      controller.stub!(:params).and_return({ id: record.id })
      controller.stub!(:model) { NewsStory }
      
      controller.get_record.should eq record
    end
    
    it "raises a RecordNotFound if ID does not exist" do
      controller.stub!(:params) { { id: "000" } }
      controller.stub!(:model) { NewsStory }
      -> { controller.get_record }.should raise_error ActiveRecord::RecordNotFound
    end
  end
  
  #-----------------
  
  describe "#get_records" do
    pending
  end

  #-----------------
  
  describe "#extend_breadcrumbs_with_resource_route" do
    pending
  end
  
  #-----------------
  
  describe "#add_user_id_to_params" do
  end  
end
