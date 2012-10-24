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
    let(:point1) { create :data_point, data_key: "point1", notes: "Point 1" }
    let(:point2) { create :data_point, data_key: "point2", notes: "Point 2" }
    let(:point3) { create :data_point, data_key: "point3", notes: "Point 3" }
    
    before :each do
      # Load the points
      point1 && point2 && point3
    end
    
    it "takes a collection and spits out a hash" do
      points = DataPoint.all
      hash   = DataPoint.to_hash(points)
      hash[point1.data_key].to_s.should eq point1.data_value
    end
    
    it "accepts an Array" do
      points = DataPoint.all.to_a
      hash = DataPoint.to_hash(points)
      hash[point1.data_key].to_s.should eq point1.data_value
    end
    
    it "creates a new DataPoint::Hashed object" do
      points = DataPoint.all
      DataPoint::Hashed.should_receive(:new).exactly(3).times
      hash = DataPoint.to_hash(points)
    end
  end
end

describe DataPoint::Hashed do
  let(:point1) { create :data_point, data_key: "point1", notes: "Point 1" }
  let(:point2) { create :data_point, data_key: "point2", notes: "Point 2" }
  let(:point3) { create :data_point, data_key: "point3", notes: "Point 3" }
  
  it "delegates data and data_key to the DataPoint" do
    hashed = DataPoint::Hashed.new(point1)
    hashed.data_value.should eq point1.data_value
    hashed.data_key.should eq point1.data_key
  end
  
  describe "#to_s" do
    it "is the data" do
      hashed = DataPoint::Hashed.new(point1)
      hashed.to_s.should eq hashed.data_value
      hashed.to_s.should eq hashed.object.data_value
    end
  end
end
