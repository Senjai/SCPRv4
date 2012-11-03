module ApplicationHelper
  include Twitter::Autolink
  
  # render_content takes a ContentBase object and a context, and renders 
  # using the most specific version of that context it can find.
  # 
  # For instance, if your content is a "news/story" and your context is 
  # "lead", render_content will try:
  # 
  # * shared/content/news/story/lead
  # * shared/content/news/lead
  # * shared/content/default/lead

  def acts_as_content?(content)
    content.class.acting_as_content
  end
  
  def present(object, klass=nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter if block_given?
    presenter
  end
  
  def render_content(content,context,options={})
    if !content
      return ''
    end

    html = ''
    
    (content.is_a?(Array) ? content : [content]).each do |c|
      if c.respond_to?(:content) && acts_as_content?(c.content)
        c = c.content
      end
      
      # if this isn't a contentbase object, assume it is broken and move on
      if !acts_as_content?(c)
        next
        
        # FIXME: Should we also be raising a notification?
      end

      # if we're caching, add content to the objects list
      if defined? @COBJECTS
        @COBJECTS << c
      end
      
      # break up our content type
      types = c.class.content_key.split("/")

      # set up our template precendence
      tmplt_opts = [
        [types[0],types[1],context].join("/"),
        [types[0],context].join("/"),
        ['default',context].join("/")
      ]

      partial = tmplt_opts.detect { |t| self.lookup_context.exists?(t,["shared/content"],true) }      
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
  
  def render_asset(content,context, fallback=false)
    if content.blank? || !content.respond_to?(:assets) || content.assets.blank?
      return fallback ? render("shared/assets/#{context}/fallback", content: content) : ''
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
  
  def random_headshot
    images = ["romo.png", "stoltze.png", "peterson.png", "moore.png", "guzman-lopez.png", "julian.png", "watt.png", "oneil.png"]
    image_tag "personalities/#{images[rand(images.size)]}"
  end
  
  #----------
  
  def smart_date_js(content, options={})
    # If we pass in something that's not a Time-y object, then look for a "published_at" attribute. 
    # Only create the time tag if there is a time-y object to work with, otherwise the tag is useless.
    if content.respond_to?(:strftime) # This is a Time or DateTime object (or something similar)
      datetime = content
    elsif content.respond_to?(:published_at) # This is an object with a published_at attribute
      datetime = content.published_at
    end
    
    if datetime ||= nil
      content_tag(:time, '', { class: "#{options[:class] + " " if options[:class]}smart smarttime", "datetime" => datetime.strftime("%FT%R"), "data-unixtime" => datetime.to_i }.merge!(options.except(:class)))  
    else
      return nil
    end
  end
  
  #----------
  
  def render_byline(content,links = true)
    if !content || !content.respond_to?(:sorted_bylines)
      return ""
    end
    
    key = "byline:#{content.cache_key}:#{links ? "links" : "text"}"
    
    # Check if we have a cache
    if cached = Rails.cache.fetch(key)
      return cached
    end
    
    authors = content.sorted_bylines
        
    # go through each list and add links where needed
    names = []
    (0..1).each do |i|
      if !authors[i] || !authors[i].any?
        next
      end
      
      authors[i].collect! do |b|
        if links && b.user && b.user.is_public
          link_to(b.user.name, bio_path(b.user.slug))
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
        byline = byels.join(" | ").html_safe
      else
        byline = ("By " + [names.join(" with "), byels.join(" | ")].join(" | ")).html_safe
      end
    else
      if names.any?
        byline = ("By " + names.join(" with ")).html_safe
      else
        byline = ""
      end
    end
    
    key = Rails.cache.write(key, byline)
    byline
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
          link_to(b.user.name, bio_path(b.user.slug))
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
      ThinkingSphinx.search('',
        :classes     => ContentBase.content_classes,
        :page        => 1,
        :per_page    => 12,
        :order       => :published_at,
        :sort_mode   => :desc,
        :with        => { category_is_news: false },
        :without     => { category: '' },
        :retry_stale => true,
        :populate    => true
      )
    rescue Riddle::ConnectionError
      []
    end
  end
  
  #----------
  
  def get_latest_news
    begin
      ThinkingSphinx.search('',
        :classes     => ContentBase.content_classes,
        :page        => 1,
        :per_page    => 12,
        :order       => :published_at,
        :sort_mode   => :desc,
        :with        => { category_is_news: true },
        :retry_stale => true,
        :populate    => true
      )
    rescue Riddle::ConnectionError
      []
    end
  end
  
  # any_to_list?: A graceful fail-safe for any Enumerable that might be blank
  # With block: returns the block if there are records, or a message if there are no records.
  # Without block: Behaves the same as `.present?`
  # Options: 
  ### wrapper: a tag to use for the wrapper. Pass false if you do not want a wrapper
  ### title: What to call the records. If you don't pass this or a message, it will return a generic message if there are no records.
  ### message: Custom message to return if there are no records.
  def any_to_list?(records, options={}, &block)
    if records.present?
      block_given? ? capture(&block) : true
    else
      if block_given?
        if options[:message].blank?
          if options[:title].present?
            options[:message] = "There are currently no #{options[:title]}".html_safe
          else
            options[:message] = "There is nothing here to list.".html_safe
          end
        end
        return options[:message] if options[:wrapper] == false
        options[:wrapper] = :span if options[:wrapper].blank? || options[:wrapper] == true
        return content_tag(options[:wrapper], options[:message], class: "none-to-list")
      else
        return false
      end
    end
  end
  
  def page_title(elements, separator=" | ")
    if @PAGE_TITLE.present?
      return @PAGE_TITLE
    end
    
    if elements.is_a? Array
      @PAGE_TITLE = elements.join(separator)
    else
      @PAGE_TITLE = elements.to_s
    end
  end
  
  #----------
  
  def link_to_audio(title, object, options={}) # This needs to be more useful
    options[:class] = "audio-toggler #{options[:class]}"
    options[:title] ||= object.short_headline
    options["data-duration"] = object.audio.available.first.duration
    content_tag :div, link_to(title, object.audio.available.first.url, options), class: "story-audio inline"
  end
  
  # easy date formatting
  # options:
  # * format: numbers (10-11-11)
  # * format: full_date (October 11th, 2011)
  # * format: event (Wednesday, October 11)
  # * no format specified: Oct 11, 2011
  # * time: true (9:35pm)
  # * with: (custom strftime string)
  def format_date(date, options={})
    return nil if !date.respond_to?(:strftime)
    
    case options[:format].to_s
      when "numbers"
        format_str = "%m-%e-%y"
      when "full_date"
        format_str = "%B #{date.day.ordinalize}, %Y"
      when "event"
        format_str = "%A, %B %e"
    end
    
    format_str = options[:with] if options[:with].present?
    format_str ||= "%b %e, %Y"
    format_str += ", %l:%M%P" if options[:time] == true
    date.strftime(format_str)
  end
  
  def modal(cssClass, options={}, &block)
    content_for(:modal_content, capture(&block))
    render('shared/modal_shell', cssClass: cssClass, options: options)
  end
  
  def watch_gmaps(options={})
    content_for :headerjs, javascript_include_tag("http://maps.googleapis.com/maps/api/js?key=#{API_KEYS["google"]["maps"]}&sensor=true")
    content_for :footerjss, "var gmapsLoader = new scpr.GMapsLoader(#{raw options.to_json});".html_safe
  end
  
  def flash_bootstrap(flash_name)
    "alert-message " + { alert: "error", notice: "success", info: "info", warning: "warning" }[flash_name]
  end
  
  def relaxed_sanitize(html)
    Sanitize.clean(html.html_safe, Sanitize::Config::RELAXED)
  end
  
  def split_collection(array, num)
    last_num  = array.size - num
    first     = array.first(num)
    last      = array.last(last_num < 0 ? 0 : last_num)
    return [first, last]
  end
end
