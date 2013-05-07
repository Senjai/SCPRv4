module Job
  class AudioVisionCache < Base
    def self.perform
      bucket = AudioVision::Bucket.find_by_key("featured-posts")
      
      if bucket.present?
        Rails.cache.write("audiovision:featured-posts", bucket.posts)
        Rails.cache.delete("views/homepage:audiovision")
      end
    end
  end
end
