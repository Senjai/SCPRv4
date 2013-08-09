class MigrateLinksToRelatedLinks < ActiveRecord::Migration
  def up
    RelatedLink.where(content_type: ["KpccProgram", "ExternalProgram"]).destroy_all

    Blog.all.each do |blog|
      blog.related_links.create(title: "Facebook", url: blog.facebook_url, link_type: "facebook") if blog.facebook_url.present?
      blog.related_links.create(title: "RSS", url: blog.feed_url, link_type: "rss") if blog.feed_url.present?
    end

    KpccProgram.all.each do |program|
      program.related_links.create(title: "Podcast", url: program.podcast_url, link_type: "podcast") if program.podcast_url.present?
      program.related_links.create(title: "RSS", url: program.rss_url, link_type: "rss") if program.rss_url.present?
      program.related_links.create(title: "Facebook", url: program.facebook_url, link_type: "facebook") if program.facebook_url.present?
    end

    ExternalProgram.all.each do |program|
      program.related_links.create(title: "Website", url: program.web_url, link_type: "website") if program.web_url.present?
    end
  end

  def down
    Blog.all.each do |blog|
      blog.related_links.destroy_all
    end

    KpccProgram.all.each do |program|
      program.related_links.destroy_all
    end

    ExternalProgram.all.each do |program|
      program.related_links.destroy_all
    end
  end
end
