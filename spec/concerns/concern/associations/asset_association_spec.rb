require "spec_helper"

describe Concern::Associations::AssetAssociation do
  subject { TestClass::Story.new }
  
  it { should have_many(:assets).class_name("ContentAsset").dependent(:destroy) }
  
  it "orders by asset_order" do
    subject.assets.to_sql.should match /order by asset_order/i
  end
end
