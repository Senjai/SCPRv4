class Admin::NewsStoriesController < Admin::ResourceController
  respond_to :html
  
  # Temporary for Cucumber...
  def create
    super
  end
end