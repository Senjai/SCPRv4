module TestClass
  class ThingWithAssets < ActiveRecord::Base
    self.table_name = "test_class_thing_with_assets"
    
    include Concern::Associations::AssetAssociation
  end
end
