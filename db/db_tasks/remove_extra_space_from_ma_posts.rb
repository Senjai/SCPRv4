# Tighten up spacing by passing it through Nokogiri::HTML::DocumentFragment.parse

blog_entries = BlogEntry.where('wp_id is not null').all

blog_entries.each do |entry|
  puts "Tightening up BlogEntry ##{entry.id}"
  parsed_content = Nokogiri::HTML::DocumentFragment.parse(entry.body)
  
  parsed_content.css('p').each do |p|
    if p.content.blank?
      p.remove
    end
  end
  
  entry.update_attributes(body: parsed_content.to_html)
end

puts "Finished"
