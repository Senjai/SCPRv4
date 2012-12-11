class NprStory < ActiveRecord::Base
  include AdminResource::Model::Identifier
  include AdminResource::Model::Naming
  
  self.table_name = "npr_npr_story"

  #---------------
  # Scopes
  
  #---------------
  # Associations

  #---------------
  # Callbacks

  #---------------
  # Administration
  self.admin = AdminResource::Admin.new(self)
  admin.define_list do
    column :headline
    column :published_at
    column :teaser
    column :link, display: :display_npr_link
  end
  
  
  #---------------
  # Sphinx
  define_index do
    indexes :headline
    indexes :teaser
    indexes :link
  end
  
  #---------------
  # Fake some AdminResource things
  class << self
    def admin_index_path
      @admin_index_path ||= Rails.application.routes.url_helpers.send("admin_#{self.route_key}_path")
    end
  end
  
  #---------------
  
  def import
  end
end
