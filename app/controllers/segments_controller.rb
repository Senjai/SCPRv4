class SegmentsController < ProgramsController
  before_filter :get_kpcc_program, only: :show # Keep this first
  before_filter :get_segment, only: :show
  
  def show    
    # check whether this is the correct URL for the segment
    if ( request.env['PATH_INFO'] =~ /\/$/ ? request.env['PATH_INFO'] : "#{request.env['PATH_INFO']}/" ) != @segment.link_path
      redirect_to @segment.link_path and return
    end
  end
  
  protected
    def get_segment
      @segment = ShowSegment.published.find(params[:id])
      rescue
        redirect_to program_path(@program)
    end
end