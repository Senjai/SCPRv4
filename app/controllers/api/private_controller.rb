class Api::PrivateController < Api::BaseController
  before_filter :authorize
  
  private
  
  def authorize
    if params[:token] != API_CONFIG['assethost']['token']
      render status: :unauthorized
      return false
    end
  end
end
