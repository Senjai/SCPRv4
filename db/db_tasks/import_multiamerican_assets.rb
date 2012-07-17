# Go through all imported posts from Multi American, and try to import any
# asset into AssetHost, add it to the post's assets, remove the element 
# from the post and save.

ah = Rails.application.config.assethost
url = URI.parse("http://#{ah.server}")
connection = Net::HTTP.new(url.host, url.port)

errors = []
successes = []

blog_entries = BlogEntry.where('wp_id is not null').all
total_entries = blog_entries.size

blog_entries.each_with_index do |blog_entry, bindex|
  bindex += 1
  boutof = "[#{bindex}/#{total_entries}]"
  parsed_content = Nokogiri::HTML::DocumentFragment.parse(blog_entry.content)
  
  # We only want to import assets from WP::Posts
  # This loop will also include BlogEntries that were imported
  # from JiffyPosts and Roundups, but we'll just skip over those
  post = WP::Post.find.find { |p| p.id == blog_entry.wp_id }
  
  if !post.present?
    puts "#{boutof} No WP::Post with id #{blog_entry.wp_id}"
    next
  end

  fake_assets = post.fake_assets(parsed_content)

  if fake_assets.blank?
    puts "#{boutof} No fake assets for WP::Post ##{post.id}"
    next
  end

  fake_assets.each_with_index do |asset, aindex|
    begin
      aindex += 1
      aoutof = "[#{aindex}/#{fake_assets.size}]"
    
      # Find this image from WP::Attachment
      attachment_id = asset['data-wp-attachment-id']
      attachment = WP::Attachment.find.find { |a| a.id == attachment_id.to_i }

      # Setup attributes
      # Attachment URL
      # All attachments have this
      src = attachment.attachment_url
    
      # Owner
      # Try to use what's stored in the WP::Attachment object
      # If it's blank then use whatever is in the blog entry body
      credit = attachment.postmeta.find { |pm| pm[:meta_key] == "_media_credit" }
      if credit
        owner = credit[:meta_value]
      else
        owner = asset.at_css('h4').try(:content)
      end
    
      # Caption
      # Use what's in the entry body since it probably has more context than
      # what's in the WP::Attachment excert attribute
      caption = asset.css('p').select { |p| p['class'].blank? }.last.try(:content)
    
      # Setup the data for the POST request to assethost
      data = {
        auth_token: ah.token,
        url:        src, 
        hidden:     "true", 
        note:       "Imported from Multi American (#{post.cache_key})",
        owner:      owner,
        caption:    caption
      }
    
      # Send the request
      response = connection.start do |http|
        # Setup the request
        request = Net::HTTP::Post.new("#{ah.prefix}/as_asset")
        request.set_form_data(data)
        http.request(request)
      end
    
      # 404? Notify and move on.
      if response.code == "404"
        errors.push ["404", post.class.name, post.id]
        puts "404 on #{src}"
        next
      end

      # Parse the JSON
      new_asset = JSON.parse(response.body)
    
      asset_desc = "WP::Attachment ##{attachment.id}  as Asset ##{new_asset['id']}  " \
        "from WP::Post ##{post.id}  to BlogEntry ##{blog_entry.id}"
    
      # Add the created asset to the blog entry's ContentAssets
      # Hardcode 44 because that's all it will be, no need
      # to make another DB request
      content_asset = ContentAsset.new(
        django_content_type_id: WP::PostBase::CONTENT_TYPE_ID,
        content:                blog_entry,
        asset_order:            aindex,
        asset_id:               new_asset["id"],
        caption:                new_asset["caption"] || ""
      )
        
      if content_asset.save
        # Remove the asset block from the post
        asset.remove
        blog_entry.content = parsed_content.to_html
        successes.push ["Saved", post.class.name, post.id]
        puts "#{boutof}#{aoutof} Saved #{asset_desc}"      
      else
        errors.push ["Can't Save", post.class.name, post.id]
        puts "Couldn't save #{asset_desc} (#{content_asset.errors})"
      end
    rescue Exception => e
      puts "#{boutof} Error on BlogEntry ##{blog_entry.id}! #{e.message}"
      next
    end
  end # fake_assets
  
  # If there is more than 1 asset, just turn it into a slideshow
  if blog_entry.assets.size > 1
    blog_entry.blog_asset_scheme = "slideshow"
  else
    # Otherwise, see what we decided earlier based on image size or
    # the previous "float"/"align" values
    if fake_assets.first['class'].match(/right/)
      blog_entry.blog_asset_scheme = "right"
    else
      blog_entry.blog_asset_scheme = ""
    end
  end
  
  blog_entry.save
end

puts "Finished with #{WP.view.pluralize(errors.size, "error")} and #{WP.view.pluralize(successes.size, "success")}."
  
puts "Errors: #{errors}"
