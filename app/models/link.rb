class Link < ActiveRecord::Base
  self.table_name   = 'media_link'
  self.primary_key = "id"

  TYPES = [
    ["Website", "website"],
    ["Related Story", "related"],
    ["PIJ Query", "query"],
    ["Video (youtube, vimeo...)", "video"],
    ["Facebook", "facebook"],
    ["Twitter", "twitter"],
    ["Document (pdf, doc, xls...)", "doc"],
    ["RSS Feed (xml)", "rss"],
    ["Podcast Feed (xml)", "podcast"],
    ["Map", "map"],
    ["Other", "other"]
  ]
  
  #--------------
  # Scopes
  default_scope where("content_type is not null")
  scope :query, -> { where(link_type: "query") }
  scope :normal, -> { where("link_type != ?", "query") }

  #--------------
  # Association
  belongs_to :content, polymorphic: true

  #--------------
  # Validation
  validates :title, :link, presence: true
  
  #--------------
  # Callbacks
  
  #----------
  
  def domain
    if self.link
      URI.parse(URI.encode(self.link)).host
    end
  end
end
