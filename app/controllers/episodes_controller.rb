class EpisodesController < ProgramsController
  before_filter :get_kpcc_program, only: :show # Keep this first
  before_filter :get_episode, only: :show
  
  def show
    @episode = @program.episodes.published.where(air_date: date).first
  end
  
  protected
    def get_episode
      @episode = @program.episodes.published.where(air_date: date).first
    end
end
