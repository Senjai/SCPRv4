class ProgramsController < ApplicationController  
  before_filter :get_ambiguous_program, only: :show
  before_filter :get_featured_programs, only: :index
  #before_filter :get_program_segments, only: :show
  before_filter :get_kpcc_program, only: [:segment, :episode]
  
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
      render :action => "show"
    else
      render :action => "show_external"
    end
  end
  
  #----------
  
  def segment
    @segment = ShowSegment.published.find(params[:id])
    
    # check whether this is the correct URL for the segment
    if ( request.env['PATH_INFO'] =~ /\/$/ ? request.env['PATH_INFO'] : "#{request.env['PATH_INFO']}/" ) != @segment.link_path
      redirect_to @segment.link_path and return
    end
  end
  
  #----------
  
  def episode
    @episode = @program.episodes.published.where(air_date: Date.new(params[:year].to_i,params[:month].to_i,params[:day].to_i)).first
    @segments = @episode.segments.published
    rescue
      redirect_to program_path(@program)
  end
  
  protected
    def get_ambiguous_program
      @program = KpccProgram.find_by_slug(params[:show]) || OtherProgram.find_by_slug(params[:show])
      redirect_to programs_path if @program.blank?
    end
    
    def get_kpcc_program
      @program = KpccProgram.find_by_slug(params[:show])
      redirect_to programs_path if @program.blank?
    end
    
    def get_featured_programs
      @featured_programs = KpccProgram.where("slug IN (?)", KpccProgram::Featured)
    end
end
