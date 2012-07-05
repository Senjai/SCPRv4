class ProgramsController < ApplicationController  
  before_filter :get_program, except: [:index, :schedule]
  before_filter :get_featured_programs, only: :index

  respond_to :html, :xml, :rss
  
  def index
    @kpcc_programs = KpccProgram.active.order("title")
    @other_programs = OtherProgram.active.order("title")
    render :layout => "application"
  end
  
  #----------
  
  def show
    # @program gets set via the before_filter
    if @program.is_a? KpccProgram
      @segments = @program.segments.published
      @episodes = @program.episodes.published
      
      # depending on what type of show this is, we need to filter some elements out of the 
      # @segments and @episodes selectors
      
      if @program.display_episodes?
        @current_episode = @program.episodes.published.first
        
        if @current_episode
          # don't return the current episode in the episodes list
          @episodes = @episodes.where("id != ?",@current_episode.id)
          
          if @current_episode.segments.published.any?
            # don't include the current episodes segments in the segments list
            @segments = @segments.where("id not in (?)", @current_episode.segments.published.collect(&:id) )
          end
        end        
      end
      
      @segments = @segments.paginate(page: params[:page], per_page: 10)
      @episodes = @episodes.paginate(page: params[:page], per_page: 6)
      
      respond_with @segments
    else
      render :action => "show_external"
    end
  end
  
  def archive
    # If the date wasn't specified, send them to the program page's archive section
    if params[:archive].blank?
      redirect_to program_path(@program, anchor: "archive-select") and return
      
    else
      @date = Time.new(params[:archive]["date(1i)"].to_i, params[:archive]["date(2i)"].to_i, params[:archive]["date(3i)"].to_i)
      @episode = ShowEpisode.where(air_date: @date, show_id: @program.id).first
     
      if @episode.blank?
        # TODO: Display some kind of notice that there is no episode
        redirect_to program_path(@program, anchor: "archive-select") and return
      else
        redirect_to @episode.link_path
      end
    end
  end
  
  #----------
  
  def segment
    @segment = ShowSegment.published.find(params[:id])
    
    # check whether this is the correct URL for the segment
    if ( request.env['PATH_INFO'] =~ /\/$/ ? request.env['PATH_INFO'] : "#{request.env['PATH_INFO']}/" ) != @segment.link_path
      redirect_to @segment.link_path and return
    end
    
    rescue
      raise ActionController::RoutingError.new("Not Found")
  end
  
  
  #----------
  
  def episode
    @episode = @program.episodes.published.where(air_date: Date.new(params[:year].to_i,params[:month].to_i,params[:day].to_i)).first
    @segments = @episode.segments.published
    rescue
      raise ActionController::RoutingError.new("Not Found")
  end

  def schedule
    @schedule_slots = Schedule.all
    render layout: "application"
  end
  
  protected
    
    # Try various ways to fetch the program the person requested
    # If nothing is found, 404
    def get_program
      @program = get_kpcc_program_by_quick_slug || get_kpcc_program_by_slug || get_other_program
      
      if !@program
        raise ActionController::RoutingError.new("Not Found")
      end
    end
    
    # ---------------
    
    def get_kpcc_program_by_slug
      if params[:show]
        KpccProgram.find_by_slug(params[:show])
      else
        return false
      end
    end
    
    def get_kpcc_program_by_quick_slug
      if params[:quick_slug]
        if program = KpccProgram.find_by_quick_slug(params[:quick_slug])
          redirect_to program_path(program) and return program
        end
      else
        return false
      end
    end
    
    def get_other_program
      OtherProgram.find_by_slug(params[:show])
    end
    
    # ---------------
    
    def get_featured_programs
      @featured_programs = KpccProgram.where("slug IN (?)", KpccProgram::Featured)
      @featured_programs.sort_by! { |program| KpccProgram::Featured.index(program.slug) } # Orders the returned records by the order of the KpccProgram::Featured array
    end
    
end
