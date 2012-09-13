class Admin::HomeController < Admin::BaseController
  def index
    @models = AdminResource.config.registered_models.map { |m| m.constantize }
    @extra_links = [
      { title: "Multi-American Import", path: admin_multi_american_path, info: "Landing page for managing the Multi-American import" }
    ]    
  end
end
