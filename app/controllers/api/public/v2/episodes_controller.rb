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
    # This is a disaster.
    def index
      binding.pry
      if @program
        if @program.uses_segments_as_episodes?
          @episodes = @program.segments
          filter_segments_by_published_at_date if @air_date
        else
          @episodes = @program.episodes
          filter_episodes_by_air_date if @air_date
        end
      else
        @episodes = ShowEpisode.published
        filter_episodes_by_air_date if @air_date
      end

      # If these two things are true, then we can assume that the program
      # uses segments as its episodes (filmweek, business update, etc.)
      @episodes = @episodes.page(@page).per(@limit).map(&:to_episode)
      respond_with @episodes
    end

    #---------------------------

    def show
      @episode = ShowEpisode.published.where(id: @id).first

      if !@episode
        render_not_found and return false
      end

      @episode = @episode.to_episode
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
        @program = Program.find_by_slug(params[:program].to_s)

        if !@program
          render_not_found(message: "Program not found. (#{params[:program]}")
        end
      end
    end


    def filter_episodes_by_air_date
      @episodes = @episodes.for_air_date(@air_date)
    end

    def filter_segments_by_published_at_date
      @episodes = @episodes.where('date(published_at) = date(?)', @air_date)
    end
  end
end
