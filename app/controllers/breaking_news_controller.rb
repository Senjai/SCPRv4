class BreakingNewsController < ApplicationController
  layout false
  
  def show
    if @breaking_news_alert = BreakingNewsAlert.get_alert
      render(template: "/breaking_news/email/template", locals: { alert: @breaking_news_alert }) and return
    end
  end
end
