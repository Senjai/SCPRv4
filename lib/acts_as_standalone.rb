# Not being used, just for reference

module ActsAsStandalone
  def acts_as_standalone
    skip_before_filter :get_records, :get_record, :extend_breadcrumbs_with_resource_root
    include InstanceMethods
  end
  
  module InstanceMethods
    # Write a blank slate
    def index; end
    def show; end
    def new; end
    def edit; end
    def create; end
    def update; end
    def destroy; end
  end
end

Admin::BaseController.extend ActsAsStandalone
