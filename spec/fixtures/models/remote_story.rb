module TestClass
  class RemoteStory < ActiveRecord::Base
    self.table_name = "test_class_remote_stories"
    
    include Concern::Validations::PublishedAtValidation
    include Concern::Validations::SlugValidation

    validates :remote_url, url: true

    def to_article
      @to_article ||= Article.new({
        :original_object    => self,
        :id                 => "test_class_remote_stories:#{id}",
        :title              => self.headline,
        :short_title        => self.short_headline,
        :public_datetime    => self.published_at,
        :teaser             => self.teaser,
        :body               => self.body,
        :byline             => "KPCC"
      })
    end
  end
end
