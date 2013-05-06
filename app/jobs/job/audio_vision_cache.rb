module Job
  class AudioVisionCache < Base
    def self.perform
      bucket = AudioVision::Bucket.find_by_key("featured-posts")
      
      if bucket.present?
        Rails.cache.write("audiovision:featured-posts", bucket.posts)
      end
    end
  end
end
