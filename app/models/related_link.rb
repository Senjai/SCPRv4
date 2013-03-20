class RelatedLink < ActiveRecord::Base
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
  validates :title, presence: true
  validates :url, presence: true, url: { allowed: [URI::HTTP, URI::FTP]}

#  alias_attribute :link, :url

  #--------------
  # Callbacks
  
  #----------
  # TODO Move this into a presenter
  def domain
    @domain ||= begin
      if self.url
        URI.parse(URI.encode(self.url)).host
      end
    end
  end
end
