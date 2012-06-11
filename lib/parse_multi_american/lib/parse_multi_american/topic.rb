module WP
  class Topic < ActiveRecord::Base
    self.table_name = "wp_posts"
  end
end