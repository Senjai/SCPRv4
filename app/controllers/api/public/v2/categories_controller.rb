module Api::Public::V2
  class CategoriesController < BaseController
    before_filter :sanitize_slug, only: [:show]

    #---------------------------
    
    def index
      @categories = Category.all
      respond_with @categories
    end
    
    #---------------------------
    
    def show
      @category = Category.where(slug: @slug).first

      if !@category
        render_not_found and return false
      end
      
      respond_with @category
    end

    #---------------------------

    private

    # ID is actually the slug.
    # Rails' routing "resources" method automatically 
    # names the id parameter to :id, but we're expecting
    # a string (the slug). It's being renamed to :slug for 
    # the variable because "id" is usually an integer, and 
    # we don't want to get confused.
    def sanitize_slug
      @slug = params[:id].to_s
    end
  end
end
