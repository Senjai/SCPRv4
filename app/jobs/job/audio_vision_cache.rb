module Job
  class AudioVisionCache < Base
    @queue = "#{namespace}:rake_tasks"

    def self.perform
      current_billboard_key = "audiovision:current_billboard"
      featured_post_key     = "scprv4:homepage:av-featured-post"

      current_billboard = AudioVision::Billboard.current
      cached_billboard  = Rails.cache.read(current_billboard_key)
      current_featured  = Rails.cache.read(featured_post_key)

      if current_billboard
        # When this task gets run:
        #
        # * If the updated timestamp of the billboard
        #   has changed, then use the first post.
        #
        # * Otherwise, use a random post that isn't
        #   the currently featured post.
        #
        if !cached_billboard || current_billboard.updated_at > cached_billboard.updated_at
          featured = current_billboard.posts.first
        else
          featured = current_billboard.posts.select { |p| p.id != current_featured.id }.sample
        end

        Rails.cache.write(current_billboard_key, current_billboard)
        Rails.cache.write(featured_post_key, featured)

        self.cache(featured, "/home/cached/audiovision", "views/home/audiovision", local: :post)
      end
    end
  end
end
