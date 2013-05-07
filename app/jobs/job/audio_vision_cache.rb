module Job
  class AudioVisionCache < Base
    @queue = namespace

    def self.perform
      billboard = AudioVision::Billboard.current
      
      if billboard.present?
        posts = billboard.posts

        Rails.cache.write("audiovision:featured-posts", posts)
        self.cache(posts.first, "/home/cached/audiovision", "views/home/audiovision", local: :post)
      end
    end
  end
end
