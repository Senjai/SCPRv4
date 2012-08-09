class ContentDefault
  include ActiveRecord::Associations
  include ActiveRecord::Reflection
  extend ActsAsContent
  
  CONTENT_TYPE = "content/default"
  acts_as_content
  
  def id
    1
  end
end
