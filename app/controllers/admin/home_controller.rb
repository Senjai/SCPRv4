class Admin::HomeController < Admin::BaseController
  def index
    @admin_models = Scprv4::Application.config.admin_models
  end
end
