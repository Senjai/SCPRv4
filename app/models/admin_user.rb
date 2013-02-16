require 'digest/sha1'

class AdminUser < ActiveRecord::Base
  self.table_name = "auth_user"
  outpost_model
  has_secretary
  
  # ----------------
  # Scopes
  scope :active, -> { where(is_active: true) }
  
  # ----------------
  # Association
  has_many :activities, class_name: "Secretary::Version", foreign_key: "user_id"
  has_one  :bio, foreign_key: "user_id"
  has_many :admin_user_permissions
  has_many :permissions, through: :admin_user_permissions
  
  # ------------------
  # Validation

  # ----------------
  # Callbacks
  before_validation :downcase_email
  before_save :digest_password, if: -> { unencrypted_password.present? }, on: :create

  # ----------------
  # Sphinx
  acts_as_searchable
  
  define_index do
    indexes username
    indexes first_name
    indexes last_name, sortable: true
  end

  attr_accessor :unencrypted_password

  # ----------------
  
  class << self
    def authenticate(username, unencrypted_password)
      if user = find_by_username(username)
        algorithm, salt, hash = user.password.split('$')
        if hash == Digest::SHA1.hexdigest(salt + unencrypted_password)
          return user
        else
          return false
        end
      else
        return false
      end
    end

    # ----------------
    
    def select_collection
      AdminUser.order("last_name").map { |u| [u.to_title, u.id] }
    end
  end
  
  #----------------
  # Check if a user can manage the passed-in resource(s)
  #
  # If multiple resources are passed in, a user must be
  # allowed to manage ALL of them in order for this to
  # return true.
  #
  # Constants must be passed in.
  #
  def can_manage?(*resources)
    self.is_superuser? or (allowed_resources & resources) == resources
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
  
  # ----------------
  # Getter and Setter for name
  # Should eventually be stored in database
  def name
    @name ||= begin
      name = [first_name, last_name].join(" ")
      name.present? ? name : "Anonymous"
    end
  end
  
  def name=(name)
    split_name = name.split(" ", 2)
    self.first_name = name[0]
    self.last_name = name[1]
    @name = name
  end

  # ----------------
  
  def allowed_resources
    @allowed_resources ||= begin
      p = self.is_superuser? ? Permission.all : self.permissions
      p.map { |p| p.resource.constantize }
    end
  end
  
  # ----------------

  private

  # ----------------
  # Setup the password digest like Mercer does
  def digest_password
    algorithm = "sha1"
    salt = rand(36**8).to_s(36)[0..4]
    hash = Digest::SHA1.hexdigest(salt + self.unencrypted_password)
    self.password = [algorithm, salt, hash].join("$")
  end

  # ----------------
  # This helps us validate that e-mails are unique,
  # because the case_sensitive validation is slow.
  def downcase_email
    self.email = email.downcase if email.present?
  end
end
