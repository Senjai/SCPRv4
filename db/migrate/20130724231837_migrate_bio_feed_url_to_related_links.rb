class MigrateBioFeedUrlToRelatedLinks < ActiveRecord::Migration
  def up
    RelatedLink.where(content_type: "Bio").destroy_all

    Bio.all.each do |bio|
      if bio.feed_url.present?
        bio.related_links.create(title: "RSS", url: bio.feed_url, link_type: "rss")
      end
    end
  end

  def down
    RelatedLink.where(content_type: "Bio").destroy_all
  end
end
