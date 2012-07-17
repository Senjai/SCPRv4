module WP
  class PostBase < Node    
    SCPR_CLASS = "BlogEntry"
    CONTENT_TYPE_ID = 44 # BlogEntry (in mercer)
    
    DEFAULTS = {
      blog_id: MultiAmerican::BLOG_ID,
      blog_slug: MultiAmerican::BLOG_SLUG,
      author_id: MultiAmerican::AUTHOR_ID,
      is_published: 0,
      blog_asset_scheme: "",
      comment_count: 0
    }
    
    XML_AR_MAP = {
      id:                 :wp_id,
      post_name:          :slug,
      title:              :title,
      content:            :content,
      pubDate:            :published_at,
      status:             :status,
      excerpt:            :_teaser
    }
    
    administrate  
    self.list_fields = [
      ['id', title: "WP-ID"],
      ['post_type'],
      ['title', link: true, display_helper: :display_or_fallback],
      ['post_name', title: "Slug"],
      ['pubDate'],
      ['status']
    ]

    # -------------------
    # Class
    
    class << self
      # -------------------      
      # Node rejectors
      
      def invalid_child(node)
        %w{comment}.include?(node.name) || 
        (Builder.is_postmeta(node) and 
          node.at_xpath("./wp:meta_value").content == "{{unknown}}") ||
        super
      end
      
      def invalid_item(node)
        # Only published content
        node.at_xpath("./wp:status").content != "publish"
      end
      
      # -------------------      
      
      def nested_attributes
        [:@categories, :@postmeta]
      end
    end
    

    # -------------------
    # Instance
    
    def initialize(element)
      @builder = { categories: [], postmeta: [] }
      super(element)
    end
    
    def sorter
      Time.parse(self.pubDate)
    end

    
    # -------------------
    # Builder for class-specific attributes
    def build_extra_attributes(object, object_builder)
      # Merge in existing author_id if user exists
      # Otherwise it will just use Leslie's ID
      if existing_user = AdminUser.where(username: self.dc).first
        object_builder[:author_id] = Bio.where(user_id: existing_user.id).first.id
      end
      
      # Create the byline
      byline = ContentByline.new(
        content: object, 
        user_id: object_builder[:author_id],
        name: ""
      )
      
      object_builder[:bylines] = [byline]
      

      # -------------------
      # Merge in Tags and Categories
      associations = [
        { name: :tags, class_name: "WP::Tag", 
          records: self.categories.select { |c| c[:domain] == "post_tag" } },
        { name: :blog_categories, class_name: "WP::Category", 
          records: self.categories.select { |c| c[:domain] == "category" } }
      ]

      associations.each do |assoc|
        assoc[:records].each do |stored_object|
          # Stored object is what gets stored with the post
          # It's a hash and just gives us the title and the slug
          
          # Tags and categories should all be in the cache
          # at this point.
          # xml_object should return a real object from cache.
          # eg., WP::Tag or WP::Category
          xml_object = assoc[:class_name].constantize.find.find do |real_obj| 
            real_obj.send(assoc[:class_name].constantize.raw_real_map.first[1]) == 
              stored_object[assoc[:class_name].constantize.raw_real_map.first[0]]
          end

          # If ar_record is present, use it. If not, import the tag.
          if xml_object.ar_record.present?
            assoc_obj = xml_object.ar_record
          else
            assoc_obj = xml_object.import
          end
          
          # Add the association object to the builder
          object.send(assoc[:name]).push assoc_obj
        end
      end
      
      
      # -------------------
      # Merge in Disqus thread ID (or nil)
      if dsq_meta = self.postmeta.find { |p| p[:meta_key] == "dsq_thread_id" }
        object.dsq_thread_id = dsq_meta[:meta_value]
      end
      
      object_builder[:content] = self.style_rules!
            
      return [object, object_builder]
    end


    # "Some" formatting rules
    # Basically a big script to conform the post into SCPR style
    def style_rules!
      # -------------------
      # Get the embeds, and insert them into body if referenced
      # Note that the video won't necessarily be referenced in the body,
      # in which case gsub! won't do anything (return nil)
      self.postmeta.select { |pm| pm[:meta_key] =~ /_oembed/ }.each do |pm|
        if (match = pm[:meta_value].match(/youtube\.com\/(?:.+?\/)?(?<vid>[\w-]+)/))
          # Got a YouTube embed
          self.content.gsub!(/^http.+?youtube.+?#{match[:vid]}.*$/, pm[:meta_value])
        
        elsif (match = pm[:meta_value].match(/vimeo\.com\/video\/(?<vid>\d+)/))
          # Got a vimeo iframe
          self.content.gsub!(/^http.+?vimeo.+?#{match[:vid]}.*$/, pm[:meta_value])
          
        elsif (match = pm[:meta_value].match(/vimeo\.com\/moogaloop.+?clip_id=(?<vid>\d+)/))
          # Got old-style vimeo embed
          self.content.gsub!(/^http.+?vimeo.+?#{match[:vid]}.*$/, pm[:meta_value])
        end
      end
      
            
      # If the post matches the [caption] tag, turn it into
      # some regular HTML
      regex = /\[caption(.+?)\](.+?)\[\/caption\]/m
      
      self.content.match(regex) do |match|
        attributes = match[1]
        content = match[2]
        style_properties = {}
        
        attributes.split("\"").each_slice(2) do |pair| 
          style_properties[pair[0].lstrip.chomp("=").to_sym] = pair[1]
        end
        
        self.content.gsub!(regex,
          WP.view.render("/admin/multi_american/attachment", 
            properties: style_properties, content: content).to_s
          )
      end
      
      
      # -------------------
      # Turn the main image into a fake AssetHost asset
      parsed_content = Nokogiri::HTML::DocumentFragment.parse(self.content, "UTF-8")
      parsed_content.css("div[@id*=attachment]").each do |div|
        
        # -------------------
        # Get caption element
        caption = div.css('p').select { |p| p['class'].blank? }.last
        
        # -------------------
        # Change credit to h4 to conform to SCPR styles
        if credit = div.at_css('p.wp-media-credit')
          credit['class'] = ""
          credit.name = "h4"
        end
        
        # Nowe remove any ghost p's caused by invalid HTML or blank caption
        parsed_content.css('p').each do |p|
          if p.content.blank?
            p.remove
          end
        end
        
        # -------------------
        # Extract the inline style from the div
        style = {}
        if div['style'].present?
          div['style'].split(';').map { |s| s.split(":") }
            .flatten.map { |s| s.strip }
            .each_slice(2) { |p| style[p[0].to_sym] = p[1] }
        end
        
        # -------------------
        # If we were told to float the image (either way), 
        # or if the image is really small,
        # render the "right" asset partial.
        # Otherwise put it in the middle
        if image = div.at_css('img')
          if %w{left right}.include?(style[:float]) || 
            style[:width].to_i.between?(1,180)
            cssClass = "right"
          else
            cssClass = "wide"
          end
          
          # Render the entire asset block into the div
          div.inner_html = WP.view.render("/admin/multi_american/asset",
            style: style, image: image.to_html, id: div['id'].split("_")[1],
            credit: credit.try(:to_html), caption: caption.try(:to_html),
            cssClass: cssClass).to_s
            
          # Finally, get rid of the main div from WP by replacing it with its own children
          div.swap(div.children)
        end
      end
      
      self.content = parsed_content.to_html
      return self.content.html_safe
    end
    
    # -------------------
    # Fake asset finder
    def fake_assets(parsed_content=nil)
      # Don't even bother with posts that haven't been imported
      # Because they don't have the fake asset pushed in yet
      if !self.imported?
        raise "Can't find fake assets if Post isn't imported."
      end
      
      # Get the ar_record for this post and parse its content,
      # then return an array of the entry's fake assets
      pc = parsed_content || Nokogiri::HTML::DocumentFragment.parse(self.ar_record.content)
      @fake_assets = pc.xpath("./div[@data-wp-attachment-id]")
    end
    
    
    # -------------------
    # Convenience Methods
    
    def to_title
      title
    end
    
    def id
      post_id.to_i
    end
    
    def status=(value)
      status_map = {
        "publish" => 5,
        "inherit" => 5,
        "draft"   => 0
      }
      
      @status = status_map[value]
    end
  end
end