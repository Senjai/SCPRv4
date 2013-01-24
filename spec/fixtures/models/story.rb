module TestClass
  class Story < ActiveRecord::Base
    self.table_name = "test_class_stories"
    
    include Concern::Scopes::SinceScope
    include Concern::Scopes::PublishedScope
    
    include Concern::Associations::AssetAssociation
    include Concern::Associations::AudioAssociation
    include Concern::Associations::ContentAlarmAssociation
    include Concern::Associations::RelatedContentAssociation
    include Concern::Associations::RelatedLinksAssociation
    include Concern::Associations::BylinesAssociation
    include Concern::Associations::CategoryAssociation
    
    include Concern::Callbacks::SetPublishedAtCallback
    include Concern::Callbacks::GenerateSlugCallback
    
    include Concern::Methods::CommentMethods
    include Concern::Methods::HeadlineMethods
    include Concern::Methods::PublishingMethods
    include Concern::Methods::StatusMethods
    include Concern::Methods::TeaserMethods
    include Concern::Methods::ContentJsonMethods
    
    include Concern::Validations::ContentValidation
    
    def obj_key
      "test_class_story:#{id}"
    end
    
    def should_generate_slug?
      self.slug.blank? && (self.pending? || self.published?)
    end
  end
end
