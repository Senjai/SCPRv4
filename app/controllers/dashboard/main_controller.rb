class Dashboard::MainController < ApplicationController

  skip_before_filter :set_up_finders, :check_sessions, :add_params_for_newrelic, only: :notify
  
  def notify
    if params[:auth_token] != Rails.application.config.api['assethost']['token']
      render text: "Unauthorized", status: :unauthorized
      return false
    end
    
    redis = Rails.cache.instance_variable_get :@data
    
    data = {
      :user        => params["user"],
      :datetime    => params["datetime"],
      :application => params["application"]
    }
    
    logger.info "Publishing deploy notification to Redis on channel scprdeploy"
    redis.publish "scprdeploy", data.to_json
    render text: "Success", status: :ok
  end
end
