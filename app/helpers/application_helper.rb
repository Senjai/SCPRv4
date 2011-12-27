module ApplicationHelper  
  
  # render_content takes a ContentBase object and a context, and renders 
  # using the most specific version of that context it can find.
  # 
  # For instance, if your content is a "news/story" and your context is 
  # "lead", render_content will try:
  # 
  # * shared/content/news/story/lead
  # * shared/content/news/lead
  # * shared/content/default/lead

  
  def render_content(content,context)
    if !content
      return ''
    end
    
    html = ''
    
    [content].flatten.each do |c|
      if c.respond_to?(:content) && c.content.is_a?(ContentBase)
        c = c.content
      end

      # if we're caching, add content to the objects list
      if defined? @COBJECTS
        @COBJECTS << c
      end
      
      # break up our content type
      types = c.class::CONTENT_TYPE.split("/")

      # set up our template precendence
      tmplt_opts = [
        [types[0],types[1],context].join("/"),
        [types[0],context].join("/"),
        ['default',context].join("/")
      ]

      partial = tmplt_opts.detect { |t| self.lookup_context.exists?(t,["shared/content"],true) }
      
      Rails.logger.debug "calling partial #{partial} for #{c}"

      html << render(:partial => "shared/content/#{partial}", :object => c, :as => :content)
    end
    
    return html.html_safe
  end
  
  #----------
  
  # render_asset takes a ContentBase object and a context, and renders using 
  # an optional context_asset_scheme attribute on the object.  
  #
  # For example, given a context of "story", render_asset will check for a 
  # story_asset_scheme attribute on the object.  If found (let's assume with a 
  # value of "wide"), it will try to render:
  #
  # * shared/assets/story/wide
  # * shared/assets/default/wide
  # * shared/assets/story/default
  # * shared/assets/default/default
  
  def render_asset(content,context)
    # short circuit if it's obvious we're getting nowhere
    if !content || !content.respond_to?("assets") || !content.assets.any?
      return ''
    end

    # look for a scheme on the content object
    scheme = content["#{context}_asset_scheme"] || "default"

    # set up our template precendence
    tmplt_opts = [
      "#{context}/#{scheme}",
      "default/#{scheme}",
      "#{context}/default",
      "default/default"
    ]
    
    partial = tmplt_opts.detect { |t| self.lookup_context.exists?(t,["shared/assets"],true) }

    render :partial => "shared/assets/#{partial}", :object => content.assets, :as => :assets, :locals => { :content => content }
  end
  
  #----------
  
  def smart_date(content)
    if !content || !content.respond_to?("public_datetime")
      return ""
    end
    
    if content.public_datetime == Date.today()
      if content.public_datetime.is_a? DateTime
        return content.public_datetime.strftime("%l:%M%P")
      else
        return "Today"
      end
    else
      return content.public_datetime.strftime("%b %e, %Y")
    end
  end
  
  #----------
  
  def render_byline(content,links = true)
    if !content || !content.respond_to?("byline_elements")
      return ""
    end    
    
    authors = [ [],[],[] ]
    
    # 1) break bylines up by role
    content.bylines.each { |b| authors[b.role] << b }

    names = []
    [0,1].each do |i|
      # 2) now sort each list by last name, first name
      authors[i] = authors[i].sort { |a,b| 
        aN = (a.user ? a.user.name : a.name).split(' ').reverse.join('')
        bN = (b.user ? b.user.name : b.name).split(' ').reverse.join('')

        aN <=> bN
      }
      
      # 3) go through each list and add links where needed
      newr = []
      authors[i].each do |b|
        if links && b.user
          newr << link_to(b.user.name, bio_path(b.user.slugged_name))
        elsif b.user
          newr << b.user.name
        else
          newr << b.name
        end
      end
      
      authors[i] = newr
      
      # 4) join the linked / unlinked names
      
      if authors[i].length == 1
        names << authors[i][0]
      elsif authors[i].length > 1
        names << [ authors[i].pop,authors[i].join(", ") ].reverse.join(' and ')
      end
    end
    
    # 5) add on any byline elements
    if content.byline_elements.length > 0
      if authors[0].length == 0 and authors[1].length == 0
        return content.byline_elements.join(" | ").html_safe
      else
        return [names.join(" with "), content.byline_elements.join(" | ")].join(" | ").html_safe
      end
    else
      return names.join(" with ").html_safe
    end
  end
  
  #----------
  
  def get_latest_arts
    content = ThinkingSphinx.search '',
      :classes    => ContentBase.content_classes,
      :page       => 1,
      :per_page   => 12,
      :order      => :published_at,
      :sort_mode  => :desc,
      :with       => { :category_is_news => false }
      
    return content    
  end
  
  #----------
  
  def get_latest_news
    content = ThinkingSphinx.search '',
      :classes    => ContentBase.content_classes,
      :page       => 1,
      :per_page   => 12,
      :order      => :published_at,
      :sort_mode  => :desc,
      :with       => { :category_is_news => true }
      
    return content
  end
end
