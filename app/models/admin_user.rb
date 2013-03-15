require 'digest/sha1'

class AdminUser < ActiveRecord::Base
  self.table_name = 'auth_user'
  
  include Outpost::Model::Authentication
  include Outpost::Model::Authorization
  outpost_model
  has_secretary

  # ----------------
  # Scopes
  
  # ----------------
  # Association
  has_many :activities, class_name: "Secretary::Version", foreign_key: "user_id"
  has_one  :bio, foreign_key: "user_id"

  # ----------------
  # Sphinx
  acts_as_searchable
  
  define_index do
    indexes username
    indexes name, sortable: true
  end

  # ----------------
  
  class << self
    def authenticate(username, unencrypted_password)
      self.find_by_username(username).try(:authenticate, unencrypted_password)
    end

    # ----------------
    
    def select_collection
      AdminUser.order("name").map { |u| [u.to_title, u.id] }
    end
  end

  # ----------------
  
  def json
    {
      :username     => self.username,
      :name         => self.name,
      :email        => self.email,
      :is_superuser => self.is_superuser,
      :headshot     => self.bio.try(:headshot) ? self.bio.headshot.thumb.url : nil
    }
  end
  
  def authenticate(unencrypted_password)
    if self.password_digest.present?
      super
    else
      authenticate_legacy(unencrypted_password)
    end
  end

  private

  def authenticate_legacy(unencrypted_password)
    algorithm, salt, hash = self.old_password.split('$')
    if hash.to_s == Digest::SHA1.hexdigest(salt.to_s + unencrypted_password)
      self.password = unencrypted_password
      self.save
      self
    else
      false
    end
  end
end
