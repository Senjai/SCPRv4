class MissedItBucket < ActiveRecord::Base
  self.table_name = "contentbase_misseditbucket"
  has_secretary
  
  #--------------------
  # Scopes
  
  #--------------------
  # Association
  has_many :contents, class_name: "MissedItContent", foreign_key: "bucket_id", order: "position asc"
  
  #--------------------
  # Validation
  validates :title, presence: true

  #--------------------
  # Callbacks
  
  #--------------------
  # Administration
  administrate do
    define_list do
      column :id
      column :title
    end
  end
  
  #--------------------
  # Sphinx
  acts_as_searchable
  
  define_index do
    indexes title
  end

  #--------------------

  class << self
    def content_key
      "missed_it"
    end
  end
end
