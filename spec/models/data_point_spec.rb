require 'spec_helper'

describe DataPoint do
  describe "validations" do
    it { should validate_presence_of(:data_key) }
    
    it "validates uniqueness of data_key" do
      create :data_point, data_key: "election_result"
      should validate_uniqueness_of(:data_key)
    end
  end
  
  describe "::to_hash" do
    let(:point1) { create :data_point, data_key: "point1", description: "Point 1" }
    let(:point2) { create :data_point, data_key: "point2", description: "Point 2" }
    let(:point3) { create :data_point, data_key: "point3", description: "Point 3" }
    
    before :each do
      # Load the points
      point1 && point2 && point3
    end
    
    it "takes a collection and spits out a hash" do
      points = DataPoint.all
      hash   = DataPoint.to_hash(points)
      hash[point1.data_key].should eq point1.data
    end
    
    it "accepts an Array" do
      points = DataPoint.all.to_a
      hash = DataPoint.to_hash(points)
      hash[point1.data_key].should eq point1.data
    end
  end
end
