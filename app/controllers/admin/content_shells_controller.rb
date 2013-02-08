class Admin::ContentShellsController < Admin::ResourceController
  #----------------

  private
  
  def search_params
    @search_params ||= {
      :order       => :published_at,
      :sort_mode   => :desc
    }
  end 
end
