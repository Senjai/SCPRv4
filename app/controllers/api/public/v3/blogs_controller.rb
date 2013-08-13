module Api::Public::V3
  class BlogsController < BaseController

    before_filter :sanitize_slug, only: [:show]

    #---------------------------

    def index
      @blogs = Blog.all

      respond_with @blogs
    end

    #---------------------------

    def show
      @blog = Blog.where(slug: @slug).first

      if !@blog
        render_not_found and return false
      end

      respond_with @blog
    end
  end
end
