module WP
  class Attachment < ActiveRecord::Base
    self.table_name = "wp_attachment"
    belongs_to :post
  end
end
