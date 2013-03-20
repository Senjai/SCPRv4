require 'digest/sha1'

class AdminUser < ActiveRecord::Base
  self.table_name = 'auth_user'
  
  include Outpost::Model::Authentication
  include Outpost::Model::Authorization
  outpost_model
  has_secretary

  # ----------------
  # Callbacks
  before_validation :generate_username, on: :create, if: -> { self.username.blank? }

  # ----------------
  # Validation

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

  # Private: Generate a username based on real name
  #
  # Returns String of the username
  def generate_username
    return nil if !self.name.present?

    names       = self.name.to_s.split
    base        = (names.first.chars.first + names.last).downcase.gsub(/\W/, "")
    dirty_name  = base

    i = 1
    while self.class.exists?(username: dirty_name)
      dirty_name = base + i.to_s
      i += 1
    end

    self.username = dirty_name
  end

  # ----------------
  # Override has_secure_password, so we can authenticate
  # with legacy password if necessary.
  def authenticate(unencrypted_password)
    if self.password_digest.present?
      super
    else
      authenticate_legacy(unencrypted_password)
    end
  end

  # ----------------

  private

  # ----------------
  # Authenticate using the django-style password.
  # Save the new password on success.
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
