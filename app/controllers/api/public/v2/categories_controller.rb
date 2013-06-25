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
  end
end
