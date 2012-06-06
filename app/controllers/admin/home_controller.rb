class Admin::HomeController < Admin::BaseController
  skip_before_filter :get_records, :extend_breadcrumbs

  def index
  end
end