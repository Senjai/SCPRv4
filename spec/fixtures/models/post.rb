module TestClass
  class Post < ActiveRecord::Base
    self.table_name = "test_class_posts"
    
    include Concern::Associations::RelatedContentAssociation
    include Concern::Associations::AssetAssociation
    include Concern::Associations::ContentAssociation
    
    has_many :content, class_name: "TestClass::PostContent", order: "position", dependent: :destroy
    
    def build_content_association(content_hash, content)
      TestClass::PostContent.new(
        :position => content_hash["position"], 
        :content  => content
      )
    end
  end
end
