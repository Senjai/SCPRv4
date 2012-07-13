class PeopleController < ApplicationController  
  def index
    @bios = Bio.where(is_public: true).order("last_name")
  end
  
  def bio
    @bio = Bio.where(is_public: true, slugged_name: params[:name]).first    
    
    if !@bio
      redirect_to staff_index_path, alert: "That staff bio no longer exists." and return false
    end
    
    @bylines = @bio.indexed_bylines(verify_natural(params[:page]))
  end
end
