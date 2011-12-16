class ProgramsController < ApplicationController
  layout "program"
  
  def index   
    @kpccprograms = KpccProgram.order("title asc")
    @otherprograms = OtherProgram.order("title asc")
    
    render :layout => "application"
  end
  
  #----------
  
  def show
    # we have to test the slug against KpccProgram, then OtherProgram
    @show = KpccProgram.where(:slug => params[:show]).first || OtherProgram.where(:slug => params[:show]).first
  end
  
  #----------
  
  def episode
    @show = KpccProgram.where(:slug => params[:show]).first
    
    date = Date.new(params[:year].to_i,params[:month].to_i,params[:day].to_i)
    @episode = @show.episodes.where(:air_date => date).first
    @upcoming = @show.episodes.first
    
  end
  
  #----------
  
  def segment
    
    @show = KpccProgram.where(:slug => params[:show]).first
    
    date = Date.new(params[:year].to_i,params[:month].to_i,params[:day].to_i)
    @episode = @show.episodes.where(:air_date => date).first

    @segment = @episode.segments.find(params[:id])
    
    render :layout => "segment"
  end
end
