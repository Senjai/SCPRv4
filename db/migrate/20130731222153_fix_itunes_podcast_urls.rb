class FixItunesPodcastUrls < ActiveRecord::Migration
  def up
    e = ExternalProgram.find(43)
    e.update_column(:podcast_url, "http://feeds.feedburner.com/tsoya")

    e = ExternalProgram.find(44)
    e.update_column(:podcast_url, "http://americanpublicmedia.publicradio.org/podcasts/xml/wits/podcast.xml")

  end

  def down
  end
end
