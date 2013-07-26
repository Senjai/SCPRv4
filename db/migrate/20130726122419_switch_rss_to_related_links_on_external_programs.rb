class SwitchRssToRelatedLinksOnExternalPrograms < ActiveRecord::Migration
  def up
    # BBC's RSS url is actually its Podcast URL. Fix it here.
    bbc = ExternalProgram.find(2)
    bbc.update_column(:podcast_url, bbc.rss_url)
    bbc.update_column(:rss_url, "")


    ExternalProgram.all.each do |program|
      if program.rss_url.present?
        program.related_links.create(title: "RSS", url: program.rss_url, link_type: "rss")
      end
    end

    remove_column :external_programs, :rss_url
  end

  def down
  end
end
