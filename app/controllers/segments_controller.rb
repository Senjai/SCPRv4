class SegmentsController < ProgramsController
  def index
  end
  
  def show
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
end