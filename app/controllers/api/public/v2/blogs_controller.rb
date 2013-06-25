module Api::Public::V2
  class BlogsController < BaseController

    before_filter :sanitize_id, only: [:show]

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

    #---------------------------

    private

    def sanitize_id
      @slug = params[:id].to_s
    end
  end
end
