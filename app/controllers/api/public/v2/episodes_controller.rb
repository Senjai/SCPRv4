module Api::Public::V2
  class EpisodesController < BaseController

    before_filter \
      :sanitize_program_slug,
      :sanitize_air_date,
      :sanitize_page,
      :sanitize_limit,
      only: [:index]

    before_filter :sanitize_id, only: [:show]

    DEFAULTS = {
      :limit => 8,
      :page  => 1
    }

    MAX_RESULTS = 16

    #---------------------------

    def index
      @episodes = ShowEpisode.published.page(@page).per(@limit)

      if @program_slug
        @episodes = @episodes.joins(:show)
          .where(KpccProgram.table_name => { slug: @program_slug })
      end

      if @air_date
        @episodes = @episodes.where(air_date: @air_date)
      end

      respond_with @episodes
    end

    #---------------------------

    def show
      @episode = ShowEpisode.published.where(id: @id).first

      if !@episode
        render_not_found and return false
      end

      respond_with @episode
    end

    #---------------------------

    private

    def sanitize_air_date
      if params[:air_date]
        begin
          @air_date = Time.parse(params[:air_date])
        rescue ArgumentError # Time couldn't be parsed
          render_bad_request(message: "Invalid Date. Format is YYYY-MM-DD.")
          return false
        end
      end
    end

    def sanitize_program_slug
      if params[:program]
        @program_slug = params[:program].to_s
      end
    end
  end
end
