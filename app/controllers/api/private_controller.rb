class Api::PrivateController < Api::BaseController
  before_filter :authorize
  
  private
  
  def authorize
    if params[:token] != Rails.application.config.api['assethost']['token']
      render status: :unauthorized
      return false
    end
  end
end
