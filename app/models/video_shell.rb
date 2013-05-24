class VideoShell < ActiveRecord::Base
  self.table_name = "contentbase_videoshell"
  outpost_model
  has_secretary

  include Concern::Scopes::SinceScope
  include Concern::Scopes::PublishedScope
  include Concern::Associations::AssetAssociation
  include Concern::Associations::BylinesAssociation
  include Concern::Associations::CategoryAssociation
  include Concern::Validations::ContentValidation
  include Concern::Validations::SlugValidation
  include Concern::Validations::PublishedAtValidation
  include Concern::Methods::StatusMethods
  include Concern::Methods::PublishingMethods
  
  #--------------------
  # Teaser just returns the body.
  def teaser
    self.body
  end

  def short_headline
    self.headline
  end

  def link_path
    "http://audiovision.scpr.org/"
  end

  def remote_link_path
    "http://audiovision.scpr.org/"
  end
end
