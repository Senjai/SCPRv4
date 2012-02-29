class ProgramsController < ApplicationController  
  before_filter :get_ambiguous_program, only: :show
  
  def index   
    @kpcc_programs = KpccProgram.order("title")
    @other_programs = OtherProgram.order("title")
    render :layout => "application"
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
    
    def date # Might use this more than once?
      Date.new(params[:year].to_i,params[:month].to_i,params[:day].to_i)
    end
end
