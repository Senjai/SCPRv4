class SwitchRssToRelatedLinksOnExternalPrograms < ActiveRecord::Migration
  def up
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
