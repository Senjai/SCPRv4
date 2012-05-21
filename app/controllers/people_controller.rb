class PeopleController < ApplicationController
  
  def bio
    @bio = Bio.where(:slugged_name => params[:name]).first
    
    if !@bio
      raise ActionController::RoutingError.new("Not Found")
    end
    
    @user_content = @bio.content(params[:page])
  end
end