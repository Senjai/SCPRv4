class User < ActiveRecord::Base
  attr_accessible :name
  has_many :activities, class_name: "Secretary::Version"
end
