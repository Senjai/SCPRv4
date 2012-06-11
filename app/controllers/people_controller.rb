class PeopleController < ApplicationController  
  def index
    @bios = Bio.where(:is_public => true).order("last_name")
  end
  
  def bio
    NewRelic::Agent.add_custom_parameters(referrer: request.referer)
    
    @bio = Bio.where(is_public: true, :slugged_name => params[:name]).first
    
    if !@bio
      raise ActionController::RoutingError.new("Not Found")
    end
    
    @bylines = @bio.indexed_bylines(params[:page])
  end
end
