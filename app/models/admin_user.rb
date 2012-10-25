class AdminUser < ActiveRecord::Base
  require 'digest/sha1'
  self.table_name = "auth_user"
  has_secretary
  
  administrate do
    define_list do
      list_per_page :all
      list_order "last_name"
      
      column :username
      column :email
      column :first_name
      column :last_name
      column :is_superuser
      column :is_staff
    end
  end
  
  
  # ----------------
  # Callbacks
  before_validation :downcase_email
  before_validation :generate_password, on: :create, if: -> { unencrypted_password.blank? }
  before_create :generate_username, if: -> { username.blank? }
  before_create :digest_password, if: -> { unencrypted_password.present? }
  
  
  # ------------------
  # Validation
  validates :email, uniqueness: true, allow_blank: true
  validates :unencrypted_password, confirmation: true
  validates_presence_of :unencrypted_password, on: :create
  
  
  # ----------------
  # Scopes
  scope :active, -> { where(is_active: true) }


  # ----------------
  # Association
  has_many :activities, class_name: "Secretary::Version", foreign_key: "user_id"
  has_one  :bio, foreign_key: "user_id"
  has_many :admin_user_permissions
  has_many :permissions, through: :admin_user_permissions
  
  # ----------------

  attr_accessor :unencrypted_password, :unencrypted_password_confirmation
  
  # ----------------

  def allowed_to?(action, resource)
    self.is_superuser? || self.permissions.where(resource: resource.to_s, action: Permission.normalize_rest(action)).first
  end
  
  # ----------------
  
  def self.authenticate(username, unencrypted_password)
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
  
  protected
  # ----------------
  # Generate a memorable password
  def generate_password
    consonants = %w(b c d f g h j k l m n p qu r s t v w x z ch cr fr nd ng nk nt ph pr rd sh sl sp st th tr)
    vowels = %w(a e i o u y)
    i, password = true, ''
    8.times do
      password << (i ? consonants[rand * consonants.size] : vowels[rand * vowels.size])
      i = !i
    end
    self.unencrypted_password, self.unencrypted_password_confirmation = password, password
  end
  
    
  # ----------------
  # Setup the password digest like Mercer does
  def digest_password
    algorithm = "sha1"
    salt = rand(36**8).to_s(36)[0..4]
    hash = Digest::SHA1.hexdigest(salt + self.unencrypted_password)
    self.password = [algorithm, salt, hash].join("$")
  end


  # ----------------
  # Bryan Ricker            #=> bricker
  # Blake Ricker            #=> bricker1
  # Bob Ricker              #=> bricker2
  # Bryan Cameron Ricker    #=> bcricker
  # Adolfo Guzman-Lopez     #=> aguzmanlopez
  def generate_username
    names = self.name.split(" ")
    uname = ""
    names[0..-2].each { |n| uname += n.chars.first }
    uname += names.last
    uname = uname.gsub(/\W/, "").downcase

    if !AdminUser.find_by_username(uname)
      self.username = uname
    else
      i = 1
      begin
        self.username = uname + i.to_s
        i += 1
      end while AdminUser.exists?(username: self.username)
    end
    self.username
  end


  # ----------------
  # This helps us validate that e-mails are unique,
  # because the case_sensitive validation is slow.
  def downcase_email
    self.email = email.downcase if email.present?
  end
  
  
  # ----------------
  # This will be used to generate auth_token when we need it
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while AdminUser.exists?(column => self[column])
  end
end
