module TestClass
  class Post < ActiveRecord::Base
    self.table_name = "test_class_posts"

    include Concern::Associations::HomepageContentAssociation
    include Concern::Associations::MissedItContentAssociation
    include Concern::Associations::FeaturedCommentAssociation
    include Concern::Associations::RelatedContentAssociation
    include Concern::Associations::AssetAssociation
    include Concern::Associations::PolymorphicProgramAssociation
    include Concern::Associations::EditionsAssociation
    include Concern::Methods::PublishingMethods
    include Concern::Methods::ContentStatusMethods

    has_many :content,
      :class_name   => "::TestClass::PostContent",
      :order        => "position",
      :dependent    => :destroy

    accepts_json_input_for :content

    def to_article
      @to_article ||= Article.new({
        :original_object    => self,
        :id                 => "posts:#{id}",
        :title              => self.headline,
        :short_title        => self.short_headline,
        :public_datetime    => self.published_at,
        :teaser             => self.teaser,
        :body               => self.body,
        :assets             => self.assets,
        :byline             => "KPCC"
      })
    end

    def to_abstract
      @to_abstract ||= Abstract.new({
        :original_object        => self,
        :headline               => self.short_headline,
        :summary                => self.teaser,
        :source                 => "KPCC",
        :url                    => "http://scpr.org",
        :assets                 => self.assets,
        :article_published_at   => self.published_at
      })
    end

    def build_content_association(content_hash, content)
      if content.published?
        TestClass::PostContent.new(
          :position => content_hash["position"].to_i,
          :content  => content
        )
      end
    end
  end
end
