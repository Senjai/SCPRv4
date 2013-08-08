class ProgramsController < ApplicationController
  before_filter :get_program, only: [:show, :episode, :archive]

  respond_to :html, :xml, :rss


  def index
    @featured_programs = KpccProgram.where(is_featured: true)
    @kpcc_programs     = KpccProgram.active.order("title")
    @external_programs = ExternalProgram.active.order("title")

    render layout: "application"
  end


  def show
    @segments = @program.segments
    @episodes = @program.episodes

    if @kpcc_program
      @segments = @segments.published
      @episodes = @episodes.published

      if request.format.html? && @program.display_episodes?
        if @current_episode = @episodes.first
          @episodes = @episodes.where("id != ?", @current_episode.id)

          if segments = @current_episode.segments.published.to_a
            @segments = @segments.where("id not in (?)", segments.map(&:id))
          end
        end
      end
    end

    # Don't want to paginate for XML response
    @segments_scoped = @segments
    @segments = @segments.page(params[:page]).per(10)
    @episodes = @episodes.page(params[:page]).per(6)

    if @kpcc_program
      respond_with @segments_scoped
    elsif @external_program
      respond_to do |format|
        format.html { render :show_external, layout: "application" }
        format.xml  { redirect_to @program.podcast_url }
      end
    end
  end


  def archive
    @date = Time.new(
      params[:archive]["date(1i)"].to_i,
      params[:archive]["date(2i)"].to_i,
      params[:archive]["date(3i)"].to_i
    )

    @episode = @program.episodes.for_air_date(@date).first

    if !@episode
      flash[:alert] = "There is no #{@program.title} " \
                      "episode for #{@date.strftime('%F')}."

      redirect_to @program.public_path(anchor: "archive") and return
    else
      redirect_to @episode.public_path
    end
  end


  def segment
    @segment = ShowSegment.published.includes(:show).find(params[:id])
    @program = @kpcc_program = @segment.show.to_program

    # check whether this is the correct URL for the segment
    if ( request.env['PATH_INFO'] =~ /\/\z/ ? request.env['PATH_INFO'] : "#{request.env['PATH_INFO']}/" ) != @segment.public_path
      redirect_to @segment.public_path and return
    end
  end


  def episode
    # Legacy route handling
    if !params[:id]
      date = Date.new(
        params[:year].to_i,
        params[:month].to_i,
        params[:day].to_i
      )

      episode = @program.to_program.episodes.for_air_date(date).first!
      redirect_to episode.public_path and return
    end

    @episode    = @program.episodes.find(params[:id]).to_episode
    @segments   = @episode.segments
  end


  def schedule
    @schedule_occurrences = ScheduleOccurrence.block(
      Time.now.beginning_of_week, 1.week
    )

    # We can't cache all of them together, since there are too many.
    # So we'll just use the most recently updated one to cache.
    @cache_object = @schedule_occurrences.sort_by(&:updated_at).last
    render layout: "application"
  end


  private

  def get_program
    @program = Program.find_by_slug!(params[:show])

    if @program.original_object.is_a? KpccProgram
      @kpcc_program = @program.original_object
    elsif @program.original_object.is_a? ExternalProgram
      @external_program = @program.original_object
    end
  end
end
