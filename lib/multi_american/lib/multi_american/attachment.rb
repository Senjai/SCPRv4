module WP
  class Attachment < ActiveRecord::Base
    self.table_name = "wp_attachment"
    belongs_to :post
    
    # title: :title,
    # pubDate: :published_at,
    # "content:encoded" => :content,
    # "excerpt:encoded" => :teaser,
    # status: :status,
    # post_name: :slug,
    # post_id: :wp_id,
    # post_type: :post_type
  end
end
