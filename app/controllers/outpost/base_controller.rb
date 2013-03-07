class Outpost::BaseController < Outpost::ApplicationController
  include Concern::Controller::CustomErrors
  
  before_filter :set_sections
  before_filter :setup_tickets
  before_filter :set_current_homepage
  
  #------------------------
  
  helper_method :admin_user
  def admin_user
    begin
      @admin_user ||= AdminUser.where(is_staff: true).find(session['_auth_user_id'])
    rescue ActiveRecord::RecordNotFound
      session['_auth_user_id'] = nil
      @admin_user              = nil
    end
  end

  #------------------------
  
  protected
  
  #------------------------
  # Just setup the @sections variable so the views can add to it.
  def set_sections
    @sections = {}
  end

  #------------------------
  # We need a new Ticket on every page, since we're offering
  # the ability to submit a ticket from any page in the CMS
  def setup_tickets
    @ticket  = Ticket.new
    @tickets = Ticket.opened
  end

  #------------------------
  # Grab the most recent homepage for the Quicknav
  def set_current_homepage
    @current_homepage = Homepage.published.first
  end
  
  #------------------------
  
  private
  
  #-------------------------
  # Override this method from CustomErrors so we can specify the template path
  def render_error(status, e=StandardError)
    render template: "/admin/errors/error_#{status}", status: status, locals: { error: e }
    report_error(e)
  end
  
  #-------------------------

  def with_rollback(object)
    object.transaction do
      yield if block_given?
      raise ActiveRecord::Rollback
    end
  end
end
