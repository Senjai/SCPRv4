class BreakingNewsController < ApplicationController
  def breaking_news
    @breaking_news_alert = BreakingNewsAlert.get_alert
  end
end