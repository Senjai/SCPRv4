class ContentEmail
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :name, :email, :subject, :body, :lname, :content

  validates :name, :email, :presence => true
  validates :lname, length: { maximum: 0 }
  validates :email, :format => { :with => %r{.+@.+\..+} }
 
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
  
  def save
    if self.valid?
      ContentMailer.email_content(self).deliver
    else
      false
    end
  end

  #---------------
  
  def save
    if self.valid?
      ContentMailer.email_content(self).deliver
      self
    else
      false
    end
  end
end
