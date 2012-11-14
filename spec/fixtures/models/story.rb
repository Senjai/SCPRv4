module TestClass
  class Story < ActiveRecord::Base
    self.table_name = "test_class_stories"
    
    include Concern::Associations::AssetAssociation
    include Concern::Associations::AudioAssociation
    include Concern::Associations::ContentAlarmAssociation
    
    include Concern::Callbacks::SetPublishedAtCallback
    
    include Concern::Methods::CommentMethods
    include Concern::Methods::HeadlineMethods
    include Concern::Methods::PublishingMethods
    include Concern::Methods::StatusMethods
    include Concern::Methods::TeaserMethods
    
    include Concern::Validations::ContentValidation
    include Concern::Validations::SlugUniqueForPublishedAtValidation
    
    include Concern::Scopes::SinceScope
  end
end
