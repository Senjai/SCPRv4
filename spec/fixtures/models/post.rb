module TestClass
  class Post < ActiveRecord::Base
    self.table_name = "test_class_posts"
    
    include Concern::Associations::HomepageContentAssociation
    include Concern::Associations::MissedItContentAssociation
    include Concern::Associations::FeaturedCommentAssociation
    include Concern::Associations::RelatedContentAssociation
    include Concern::Associations::AssetAssociation
    include Concern::Methods::PublishingMethods
    include Concern::Methods::StatusMethods
    
    has_many :content, class_name: "::TestClass::PostContent", order: "position", dependent: :destroy
    accepts_json_input_for_content
    
    def build_content_association(content_hash, content)
      TestClass::PostContent.new(
        :position => content_hash["position"].to_i, 
        :content  => content
      )
    end
  end
end
