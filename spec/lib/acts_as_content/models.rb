class ContentDefault
  include ActiveRecord::Associations
  include ActiveRecord::Reflection
  extend ActsAsContent
  
  acts_as_content

  def self.content_key
    "content/default"
  end
  
  def id
    1
  end
end
