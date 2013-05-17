module Api::Private::V1
  class UtilityController < BaseController
    def notify
      
      data = {
        :user        => params["user"],
        :datetime    => params["datetime"],
        :application => params["application"]
      }
      
      logger.info "Publishing deploy notification to Redis on channel scprdeploy"
      
      $redis.publish "scprdeploy", data.to_json
      render text: "Success", status: :ok
    end
  end
end
