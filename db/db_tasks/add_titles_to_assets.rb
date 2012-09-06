# The initial assethost import from MA didn't bring in titles
# So this script does that

ah         = Rails.application.config.assethost
url        = URI.parse("http://#{ah.server}")
connection = Net::HTTP.new(url.host, url.port)

puts "Pushing to #{url}"

blog_entries  = BlogEntry.where('wp_id is not null').all
total_entries = blog_entries.size

success_ct = 0
error_ct   = 0

blog_entries.each_with_index do |blog_entry, bindex|
  bindex += 1
  boutof = "[#{bindex}/#{total_entries}]"
  
  if blog_entry.assets.blank?
    puts "#{boutof} No assets for BlogEntry ##{blog_entry.id}"
    success_ct += 1
    next
  end
  
  blog_entry.assets.each do |asset|
    # Find the asset from the URL in the notes
    attachment_url = asset.asset.json["notes"].match(/Fetched from URL: (.+?)\n/)[1]
    
    # Get that attachment from cache
    attachment = MultiAmerican::Attachment.find.find { |a| a.attachment_url == attachment_url }
    
    # Short circuit if the attachment isn't found for some reason.
    if !attachment
      puts "#{boutof} FAILURE: Attachment not found with url #{attachment_url}"
      error_ct += 1
      next
    end
    
    # Short circuit if the title is empty anyways
    if attachment.title.empty?
      puts "#{boutof} No title for MultiAmerican::Attachment #{attachment.id}"
      success_ct += 1
      next
    end
    
    # Short circuit if the asset already has a title
    if asset.title.present?
      puts "#{boutof} Title already exists for Asset ##{asset.id}"
      success_ct += 1
      next
    end
    
    # Setup the data to send
    data = {
      auth_token: ah.token,
      asset: {
        title: attachment.title
      }
    }
    
    # Send the request
    response = connection.start do |http|
      # Setup the request
      request = Net::HTTP::Put.new("#{ah.prefix}/assets/#{asset.asset_id}")
      request.set_form_data("auth_token" => ah.token, "asset[title]" => attachment.title)
      http.request(request)
    end

    # 404? Notify and move on.
    if response.code == "404"
      puts "#{boutof} FAILURE: 404 on Asset ##{asset.asset_id} for BlogEntry ##{blog_entry.id}"
      error_ct += 1
      next
    end
    
    # Parse the JSON
    updated_asset = JSON.parse(response.body)
    if updated_asset["title"] == attachment.title
      puts "#{boutof} Updated title from MultiAmerican::Attachment ##{attachment.id} to Asset ##{updated_asset["id"]}"
      success_ct += 1
      next
    else
      puts "#{boutof} FAILURE: Title not updated for Asset ##{updated_asset["id"]}"
      error_ct += 1
      next
    end
  end
end

puts "Finished. #{success_ct} Successes; #{error_ct} Errors."
    
