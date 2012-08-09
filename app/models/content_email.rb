class ContentEmail

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :name, :email, :subject, :body, :url, :headline, :teaser

  validates :name, :email, :presence => true
  validates :email, :format => { :with => %r{.+@.+\..+} }
 
 def initialize(attributes = {})
   attributes.each do |name, value|
     send("#{name}=", value)
   end
 end

  def persisted?
   false
  end

end