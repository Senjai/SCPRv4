class ProgramsController < ApplicationController
  before_filter :get_any_program, only: [:show, :episode]
  before_filter :get_kpcc_program!, only: [:archive]

  respond_to :html, :xml, :rss


  def index
    @featured_programs = KpccProgram.where(is_featured: true)
    @kpcc_programs     = KpccProgram.active.order("title")
    @external_programs = ExternalProgram.active.order("title")
    render layout: "application"
  end


  def show
    # @program gets set via the before_filter
    if @program.is_a? KpccProgram
      @segments = @program.segments.published
      @episodes = @program.episodes.published

      # depending on what type of show this is, we need to filter some 
      # elements out of the @segments and @episodes selectors
      # Only for HTML response
      if request.format.html?
        if @program.display_episodes?
          @current_episode = @episodes.first

          if @current_episode
            # don't return the current episode in the episodes list
            @episodes = @episodes.where("id != ?",@current_episode.id)

            if @current_episode.segments.published.any?
              # don't include the current episodes segments in the 
              # segments list
              @segments = @segments.where("id not in (?)", 
                @current_episode.segments.published.collect(&:id))
            end
          end
        end
      end

      # Don't want to paginate for XML response
      @segments_scoped = @segments
      @segments = @segments.page(params[:page]).per(10)
      @episodes = @episodes.page(params[:page]).per(6)

      respond_with @segments_scoped
    else
      respond_to do |format|
        format.html { render :show_external }
        format.xml  { redirect_to @program.podcast_url }
      end
    end
  end


  def archive
    @date = Time.new(params[:archive]["date(1i)"].to_i, params[:archive]["date(2i)"].to_i, params[:archive]["date(3i)"].to_i)
    @episode = @program.episodes.published.for_air_date(@date).first

    if !@episode
      flash[:alert] = "There is no #{@program.title} episode for #{@date.strftime('%F')}."
      redirect_to program_path(@program.slug, anchor: "archive") and return
    else
      redirect_to @episode.public_path
    end
  end


  def segment
    @segment = ShowSegment.published.includes(:show).find(params[:id])
    @program = @segment.show

    # check whether this is the correct URL for the segment
    if ( request.env['PATH_INFO'] =~ /\/\z/ ? request.env['PATH_INFO'] : "#{request.env['PATH_INFO']}/" ) != @segment.public_path
      redirect_to @segment.public_path and return
    end
  end


  def episode
    # Legacy route handling
    if !params[:id]
      date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
      episode = @program.to_program.episodes.for_air_date(date).first!
      redirect_to episode.public_path and return
    end


    if @program.is_a? KpccProgram
      @episode = @program.episodes.published.find(params[:id])
      @segments = @episode.segments.published
      render :episode
    else
      @episode = @program.external_episodes.find(params[:id])
      render :external_episode
    end
  end


  def schedule
    @schedule_occurrences = ScheduleOccurrence.block(Time.now.beginning_of_week, 1.week)

    # We can't cache all of them together, since there are too many.
    # So we'll just use the most recently updated one to cache.
    @cache_object = @schedule_occurrences.sort_by(&:updated_at).last
    render layout: "application"
  end


  private

  def get_any_program
    @program = KpccProgram.find_by_slug(params[:show]) || ExternalProgram.find_by_slug(params[:show])

    if !@program
      render_error(404, ActionController::RoutingError.new("Not Found")) and return false
    end
  end

  def get_kpcc_program!
    @program = KpccProgram.find_by_slug!(params[:show])
  end
end
