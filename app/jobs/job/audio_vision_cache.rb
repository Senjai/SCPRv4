module Job
  class AudioVisionCache < Base
    def self.perform
      bucket = AudioVision::Bucket.find_by_key("featured-posts")
      
      if bucket.present?
        posts = bucket.posts

        Rails.cache.write("audiovision:featured-posts", posts)
        self.cache(posts.first, "/home/cached/audiovision", "views/home/audiovision", local: :post)
      end
    end
  end
end
