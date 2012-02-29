class EpisodesController < ProgramsController
  before_filter :get_kpcc_program
  
  def index
    @episodes = @program.episodes
  end
  
  def show
    @episode = @program.episodes.published.where(air_date: date).first
    redirect_to program_path(@program.slug)
  end
end
