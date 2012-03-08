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

  
  def render_content(content,context,options={})
    if !content
      return ''
    end
    
    html = ''
    
    [content].flatten.each do |c|
      if c.respond_to?(:content) && c.content.is_a?(ContentBase)
        c = c.content
      end
      
      # if this isn't a contentbase object, assume it is broken and move on
      if !c.is_a?(ContentBase)
        next
        
        # FIXME: Should we also be raising a notification?
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
      
      html << render(options.merge({:partial => "shared/content/#{partial}", :object => c, :as => :content}))
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
  
  def smart_date(content,options={})
    options = {
      :today_template => "%-I:%M%P",
      :template       => "%b %e, %Y"
    }.merge(options)
    
    if !content || !content.respond_to?("public_datetime")
      return ""
    end
    
    if content.public_datetime.to_date == Date.today()
      if content.public_datetime.is_a? Time
        return content.public_datetime.strftime(options[:today_template])          
      else
        return "| Today"
      end
    elsif options && options[:today]
      # we only want a date if it is today's date, so return nothing
      return ''
    else
      return content.public_datetime.strftime(options[:template])
    end
  end
  
  #----------
  
  def render_byline(content,links = true)
    if !content || !content.respond_to?(:sorted_bylines)
      return ""
    end    
    
    authors = content.sorted_bylines
        
    # go through each list and add links where needed
    names = []
    (0..1).each do |i|
      if !authors[i] || !authors[i].any?
        next
      end
      
      authors[i].collect! do |b|
        if links && b.user
          link_to(b.user.name, bio_path(b.user.slugged_name))
        elsif b.user
          b.user.name
        else
          b.name
        end
      end
        
      if authors[i].length == 1
        names << authors[i][0]
      elsif authors[i].length > 1
        names << [ authors[i].pop,authors[i].join(", ") ].reverse.join(' and ')
      end
    end
    
    # add on any byline elements
    
    byels = content.byline_elements.collect { |e| e && e != '' ? e : nil }.compact
    
    if byels.length > 0
      if authors[0].length == 0 and authors[1].length == 0
        return byels.join(" | ").html_safe
      else
        return ("By " + [names.join(" with "), byels.join(" | ")].join(" | ")).html_safe
      end
    else
      if names.any?
        return ("By " + names.join(" with ")).html_safe
      else
        return ""
      end
    end
  end
  
  #----------
  
  def render_contributing_byline(content,links=true)
    if !content || !content.respond_to?(:sorted_bylines)
      return ""
    end    
    
    authors = content.sorted_bylines
    
    if authors[2] && authors[2].any?
      # go through each list and add links where needed
      authors[2].collect! do |b|
        if links && b.user
          link_to(b.user.name, bio_path(b.user.slugged_name))
        elsif b.user
          b.user.name
        else
          b.name
        end
      end    
    
      return "With contributions by #{ authors[2].length == 1 ? authors[2][0] : [ authors[2].pop,authors[2].join(", ") ].reverse.join(' and ') }.".html_safe
    
    else
      return ""
    end
  end
  
  # Convert a given number of seconds into a human-readable duration. 
  
  def format_duration(secs)
    if !secs
      return ''
    end
    
    [[60, :sec], [60, :min], [24, :hr], [1000, :days]].map{ |count, name|
      if secs > 0
        secs, n = secs.divmod(count)
        "#{n.to_i} #{name}"
      end
    }.compact.reverse.join(' ')
  end
  
  #----------
  
  def get_latest_arts
    begin
      ThinkingSphinx.search '',
        :classes    => ContentBase.content_classes,
        :page       => 1,
        :per_page   => 12,
        :order      => :published_at,
        :sort_mode  => :desc,
        :with       => { :category_is_news => false },
        :without    => { :category => '' }
    rescue Riddle::ConnectionError # If Sphinx is not running.
      return "Arts currently unavailable."
    end
  end
  
  #----------
  
  def get_latest_news
    begin
      ThinkingSphinx.search '',
        :classes    => ContentBase.content_classes,
        :page       => 1,
        :per_page   => 12,
        :order      => :published_at,
        :sort_mode  => :desc,
        :with       => { :category_is_news => true }
    rescue Riddle::ConnectionError # If Sphinx is not running.
      return "News currently unavailable."
    end
  end
  
  def any_to_list?(records, options={}, &block)
    if records.present?
      block_given? ? capture(&block) : true
    else
      if block_given?
        options[:title] ||= records.class.to_s.titleize.pluralize
        options[:message] ||= "<span class='none-to-list'>There are currently no #{options[:title]}</span>".html_safe
      else
        return false
      end
    end
  end
  
  def page_title(elements, separator=" | ")
    if elements.is_a? Array
      @PAGE_TITLE = elements.join(separator)
    else
      @PAGE_TITLE = elements.to_s
    end
  end
  
  def link_to_audio(title, object, options={}) # This needs to be more useful
    options[:class] = "audio-toggler #{options[:class]}"
    options[:title] ||= object.headline
    content_tag :div, link_to(title, object.audio.first.url, options), class: "story-audio inline"
  end
end
