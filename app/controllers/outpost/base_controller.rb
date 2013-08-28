class Outpost::BaseController < Outpost::ApplicationController
  before_filter :set_current_homepage
  before_filter :add_params_for_newrelic
  before_filter :set_flash_from_query_string

  #------------------------
  # Grab the most recent homepage for the Quicknav
  def set_current_homepage
    @current_homepage = Homepage.published.first
  end

  #-------------------------

  def add_params_for_newrelic
    if current_user
      NewRelic::Agent.add_custom_parameters(
        :current_user_id   => current_user.id, 
        :current_user_name => current_user.name
      )
    end
  end

  #-------------------------
  # Override this method from CustomErrors so we can specify the template path
  def render_error(status, e=StandardError)
    if Rails.application.config.consider_all_requests_local
      raise e
    else
      render template: "/outpost/errors/error_#{status}", status: status, locals: { error: e }
    end

    report_error(e)
  end

  #-------------------------

  def set_flash_from_query_string
    Array(params[:notifications]).each do |key, message|
      flash.now[key] = message
    end
  end
end
