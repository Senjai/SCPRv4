module Api::Public::V2
  class BreakingNewsAlertsController < BaseController

    before_filter :sanitize_slug, only: [:show]

    def index
      @breaking_news_alerts = BreakingNewsAlert.published
      respond_with @breaking_news_alerts
    end
  end
end
