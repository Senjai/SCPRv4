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
      :limit => 4,
      :page  => 1
    }

    MAX_RESULTS = 8

    #---------------------------

    def index
      @program = Program.find_by_slug(@program_slug)

      if !@program
        render_not_found and return false
      end

      @episodes = @program.episodes.page(@page).per(@limit)

      if @air_date
        @episodes = @episodes.where('DATE(air_date) = DATE(?)', @air_date)
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
      else
        render_bad_request(message: "program is a required parameter.")
      end
    end
  end
end
