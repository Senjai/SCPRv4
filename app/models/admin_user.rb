class AdminUser < ActiveRecord::Base
  require 'digest/sha1'
  
  self.table_name = "auth_user"
  
  include ActiveModel::SecureAttribute
  has_secure_attribute :passw
  attr_accessor :passw_confirmation
  
  before_validation :downcase_email
  
  validates :name, presence: true
  validates :email, uniqueness: true, allow_blank: true

  before_create :generate_username, if: -> { username.blank? }
  before_create { generate_token(:auth_token) }
  
  scope :active, where(:is_active => true)

  # Temporarily authenticate with SHA1 for Mercer
  def self.authenticate(username, unencrypted_password)
    if user = find_by_username(username)
      user.authenticate_legacy(unencrypted_password)
    else
      false
    end
  end
  
  def authenticate_legacy(unencrypted_password)
    algorithm, salt, hash = self.password.split('$')
    if hash == Digest::SHA1.hexdigest(salt + unencrypted_password)
      self.passw, self.passw_confirmation = unencrypted_password
      generate_token(:auth_token)
      save!
      self
    else
      false
    end
  end
  
  def as_json(*args)
    {
      id: self.id,
      username: self.username,
      name: self.name,
      email: self.email,
      is_superuser: self.is_superuser
    }
  end
  
  def generate_username
    # Bryan Ricker            #=> bricker
    # Blake Ricker            #=> bricker1
    # Bob Ricker              #=> bricker2
    # Bryan Cameron Ricker    #=> bcricker
    # Adolfo Guzman-Lopez     #=> aguzmanlopez
    
    names = self.name.split(" ")
    username = ""
    names[0..-2].each { |n| username += n.chars.first }
    username += names.last
    username = username.gsub(/\W/, "").downcase

    if !AdminUser.find_by_username(username)
      self.username = username
    else
      i = 1
      begin
        self.username = username + i.to_s
        i += 1
      end while AdminUser.exists?(username: self.username)
    end
    self.username
  end
  
  protected
  
    # This helps us validate that e-mails are unique,
    # because the case_sensitive validation is slow.
    def downcase_email
      self.email = email.downcase if email.present?
    end
    
    def generate_token(column)
      begin
        self[column] = SecureRandom.urlsafe_base64
      end while AdminUser.exists?(column => self[column])
    end
end
