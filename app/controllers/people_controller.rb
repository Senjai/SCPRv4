class PeopleController < ApplicationController
  
  def index
    @bios = Bio.where(:is_public => true).order("last_name")
  end
  
  def bio
    @bio = Bio.where(is_public: true, :slugged_name => params[:name]).first
    
    if !@bio
      raise ActionController::RoutingError.new("Not Found")
    end
    
    @user_content = @bio.content(params[:page])
  end
end
