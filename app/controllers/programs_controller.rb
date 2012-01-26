class ProgramsController < ApplicationController
  layout "content_8_4"
  
  before_filter :load_program, :except => [:index]
  before_filter :require_kpcc_program, :only => [:episode,:segment]
  
  def index   
    @kpccprograms = KpccProgram.order("title asc")
    @otherprograms = OtherProgram.order("title asc")
  end
  
  #----------
  
  def show
    # we'll only get into the function if @program is set, and that's all we need
  end
  
  #----------
  
  def episode    
    date = Date.new(params[:year].to_i,params[:month].to_i,params[:day].to_i)
    
    @episode = @program.episodes.published.where(:air_date => date).first
    
    if !@episode
      redirect_to program_path(@program.slug) and return
    end    
  end
  
  #----------
  
  def segment
    # does the segment with this id exist?
    begin
      @segment = ShowSegment.published.find(params[:id])
    rescue
      redirect_to program_path(@program.slug) and return
    end
    
    # check whether this is the correct URL for the segment
    if ( request.env['PATH_INFO'] =~ /\/$/ ? request.env['PATH_INFO'] : "#{request.env['PATH_INFO']}/" ) != @segment.link_path
      redirect_to @segment.link_path and return
    end        
  end
  
  #----------
  
  protected
  
  def load_program
    @program = KpccProgram.where(:slug => params[:show]).first || OtherProgram.where(:slug => params[:show]).first
    
    if !@program
      redirect_to programs_path
    end
  end
  
  def require_kpcc_program
    if !@program || !@program.is_a?(KpccProgram)
      redirect_to programs_path
    end
  end
end
