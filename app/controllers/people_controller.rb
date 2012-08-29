class PeopleController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :redirect_to_staff_index
  
  def index
    @bios = Bio.where(is_public: true).order("last_name")
  end
  
  def bio
    @bio     = Bio.find_by_is_public_and_slugged_name!(true, params[:name])    
    @bylines = @bio.indexed_bylines(verify_natural(params[:page]))
  end
  
  protected
    def redirect_to_staff_index
      redirect_to staff_index_path, alert: "That staff bio no longer exists." and return false
    end
  #
end
