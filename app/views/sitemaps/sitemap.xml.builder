xml.instruct!(:xml, version: "1.0", encoding: "UTF-8")
xml.urlset xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9" do
  @content.each do |object|
    xml.url do
      xml.loc         object.public_url
      xml.changefreq  @changefreq || "daily"
      xml.priority    @priority || "0.5"
      
      if object.respond_to? :published_at
        xml.lastmod   object.published_at.utc.strftime("%Y-%m-%dT%H:%M:%S+00:00")
      end
    end
  end
end
