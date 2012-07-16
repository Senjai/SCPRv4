module WP
  class JiffyPost < PostBase
    XPATH = "//item/wp:post_type[text()='jiffypost']/.."      
    self.list_fields = PostBase.list_fields
    
    def style_rules!
      # Format jiffy posts a little better
      parsed_content = Nokogiri::HTML::DocumentFragment.parse(self.content, "UTF-8")
      
      if source_ul = parsed_content.at_css('ul.embed-metadata')
        # Ditch the source icon
        if icon = source_ul.at_css('li.jiffy-icon')
          icon.remove
        end
        
        # For some reason not all of these have the `.jiffy-source` class,
        # so we need to do it based on content, so we can do something to
        # it later if we want.
        if source_li = source_ul.css("li").find { |li| li.content =~ /^Source/ }
          source_li['class'] = "jiffy-source"
        end
      end
        
      # Float the thumbnail right
      if img = parsed_content.at_css('img.embedlyThumbnail')
        style = img['style'].to_s 
        style += " float: right; padding: 0 0 7px 7px;"
        img['style'] = style
      end
      
      # Remove the Apple-style-span class and style
      spans = parsed_content.css("span.Apple-style-span").each do |span|
        span['class'] = ""
        span['style'] = ""
      end

      parsed_content.css('p').each do |p|
        # Now simple_format the content
        dup = p.inner_html.dup
        p.inner_html = WP.view.simple_format(dup)
        
        # Now remove/replace the characters that shouldn't be there...
#        dup = p.inner_html.dup
#        p.inner_html = dup.gsub(/Â/, "").gsub(/â\?\??/, "")
      end
            
      # remove style from some elements to conform to our styles
      parsed_content.css('p,a,strong,li,ul').each do |n|
        n['style'] = ""
      end
      
      self.content = parsed_content.to_html
      
      super
    end
  end
end
