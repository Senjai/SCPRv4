module Api::Public::V2
  class EditionsController < BaseController
    DEFAULTS = {
      :page  => 1,
      :limit => 2
    }

    MAX_RESULTS = 4

    before_filter \
      :sanitize_limit, 
      :sanitize_page,
      only: [:index]


    before_filter :sanitize_id, only: [:show]

    #---------------------------

    def index
      @editions = Edition.includes(:slots).published.page(@page).per(@limit)
      respond_with @editions
    end

    #---------------------------

    def show
      @edition = Edition.includes(:slots).published.where(id: @id).first

      if !@edition
        render_not_found and return false
      end

      respond_with @edition
    end
  end
end
