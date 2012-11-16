Feedzirra::Feed.add_common_feed_entry_element :enclosure, :value => :url, :as => :enclosure_url
Feedzirra::Feed.add_common_feed_entry_element :enclosure, :value => :type, :as => :enclosure_type

# Ignore a feed if it returns an error nil
module Feedzirra
  class Feed
    def self.safe_fetch_and_parse(url, &block)
      feed = Feedzirra::Feed.fetch_and_parse(url)
      if feed.present? && !feed.is_a?(Fixnum)
        yield feed
      end
    end
  end
end
