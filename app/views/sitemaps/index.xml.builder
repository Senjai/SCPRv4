xml.instruct!(:xml, version: "1.0", encoding: "UTF-8")
xml.sitemapindex xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9" do
  @sitemaps.each do |sitemap|
    xml.sitemap do
      xml.loc         sitemap_url(sitemap) + ".xml"
    end
  end
end
