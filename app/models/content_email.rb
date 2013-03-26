##
# ContentEmail
#
# An e-mail associated with any object
#
class ContentEmail
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :from_name, :from_email, :to_email, :subject, :body, :lname, :content

  validates :from_email, :to_email, presence: true, format: { with: %r{\A\S+?@\S+?\.\S+\z}, message: "is an invalid e-mail format." }
  validates :content,               presence: true
  validates :lname,                 length: { maximum: 0 }
 
  #---------------
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end    
  end

  #---------------

  def persisted?
   false
  end

  #---------------
  
  def save
    return false unless self.valid?

    begin
      ContentMailer.email_content(self).deliver
      self
    rescue SimplePostmark::APIError => e
      self.errors.add(:base, e.message)
      false
    end
  end
  
  #---------------
  
  def from
    if self.from_name.present?
      self.from_name
    else
      self.from_email
    end
  end
end
