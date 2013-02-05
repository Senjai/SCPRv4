module ApplicationHelper
  include Twitter::Autolink

  #---------------------------
  
  def present(object, klass=nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter if block_given?
    presenter
  end
  
  #---------------------------
  # render_content takes a ContentBase object and a context, and renders 
  # using the most specific version of that context it can find.
  # 
  # For instance, if your content is a "news/story" and your context is 
  # "lead", render_content will try:
  # 
  # * shared/content/news/story/lead
  # * shared/content/news/lead
  # * shared/content/default/lead
  #
  def render_content(content,context,options={})
    if !content
      return ''
    end

    html = ''
    
    (content.is_a?(Array) ? content : [content]).each do |c|
      if c.respond_to?(:content)
        c = c.content
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
  
  #---------------------------  
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
    images = ["romo.png", "stoltze.png", "peterson.png", "moore.png", "guzman-lopez.png", "julian.png", "watt.png", "oneil.png", "trujillo.png"]
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
  # Render a byline for the passed-in content
  # If links is set to false, and the contet has
  # bylines, this will yield the same as +content.byline+
  # 
  # If the content doesn't have bylines, just return
  # "KPCC" for opengraph stuff.
  def render_byline(content, links=true)
    return "KPCC" if !content.respond_to?(:bylines)
    
    elements = content.joined_bylines do |bylines|
      link_bylines(bylines, links)
    end

    ContentByline.digest(elements).html_safe
  end
  
  #---------------------------
  
  def render_contributing_byline(content,links=true)
    elements = content.joined_bylines do |bylines|
      link_bylines(bylines, links)
    end
    
    if elements[:contributing].present?
      "With contributions by #{elements[:contributing]}".html_safe
    else
      ""
    end
  end

  #---------------------------
  # Return an array of the passed-in bylines
  # either tranformed into links, or just
  # the name.
  #
  # This is mostly for +render_byline+ and
  # +render_contributing_byline+ to share.
  def link_bylines(bylines, links)
    bylines.map do |byline|
      if !!links && byline.user.try(:is_public)
        link_to byline.display_name, byline.user.link_path
      else
        byline.display_name
      end
    end
  end
  
  #---------------------------
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
    ContentBase.search({
      :limit       => 12,
      :with        => { category_is_news: false },
      :without     => { category: '' }
    })
  end
  
  #----------
  
  def get_latest_news
    ContentBase.search({
      :limit       => 12,
      :with        => { category_is_news: true }
    })
  end
  
  #---------------------------
  # any_to_list?: A graceful fail-safe for any Enumerable that might be blank
  # With block: returns the block if there are records, or a message if there are no records.
  # Without block: Behaves the same as `.present?`
  # Options: 
  ### wrapper: a tag to use for the wrapper. Pass false if you do not want a wrapper
  ### title: What to call the records. If you don't pass this or a message, it will return a generic message if there are no records.
  ### message: Custom message to return if there are no records.
  def any_to_list?(records, options={}, &block)
    if records.present?
      return capture(&block)
    else
      if options[:message].blank?
        if options[:title].present?
          options[:message] = "There are currently no #{options[:title]}"
        else
          options[:message] = "There is nothing here to list."
        end
      end

      return options[:message].html_safe
    end
  end
  
  #---------------------------
  # Sets the page title.
  #
  # Pass in a string or an array of strings.
  # Takes an optional separaptor argument.
  #
  # Example:
  #
  #   <% page_title [@event.headline, "Forum"] %>
  #
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
  
  #---------------------------
  # easy date formatting
  # options:
  # * format: iso (2012-10-11)
  # * format: full_date (October 11th, 2011)
  # * format: event (Wednesday, October 11)
  # * no format specified: Oct 11, 2011
  # * time: true (9:35pm)
  # * with: (custom strftime string)
  def format_date(date, options={})
    return nil if !date.respond_to?(:strftime)
    
    format_str = options[:with] if options[:with].present?

    format_str ||= case options[:format].to_s
      when "iso"       then "%F"
      when "full_date" then "%B #{date.day.ordinalize}, %Y"
      when "event"     then "%A, %B %e"
    end
    
    format_str ||= "%b %e, %Y"
    format_str += ", %l:%M%P" if options[:time] == true

    date.strftime(format_str)
  end
  
  #---------------------------
  
  def modal(cssClass, options={}, &block)
    content_for(:modal_content, capture(&block))
    render('shared/modal_shell', cssClass: cssClass, options: options)
  end

  #---------------------------
  
  def relaxed_sanitize(html)
    Sanitize.clean(html.html_safe, Sanitize::Config::RELAXED)
  end
  
  #---------------------------
  
  def split_collection(array, num)
    last_num  = array.size - num
    first     = array.first(num)
    last      = array.last(last_num < 0 ? 0 : last_num)
    return [first, last]
  end

  #---------------------------

  def featured_comment(opts)
    opts = { :style => "default", :bucket => nil, :comment => nil }.merge(opts||{})
        
    comment = nil
    
    if opts[:comment]
      if opts[:comment].is_a?(FeaturedComment)
        comment = opts[:comment]
      else
        begin
          comment = FeaturedComment.find(opts[:comment])
        rescue
          return ''
        end
      end
    elsif opts[:bucket]
      bucket = FeaturedCommentBucket.find(opts[:bucket])
      comment = bucket.comments.published.first()
    else
      comment = FeaturedComment.published.first()
    end
    
    if comment && comment.content
      return render(:partial => "shared/featured_comment/#{opts[:style]}", :object => comment, :as => :comment)
    end
  end
  
  #----------
  
  def comment_widget_for(object, options={})
    if object.present? and object.respond_to?(:disqus_identifier)
      render('shared/cwidgets/comment_count', { content: object, cssClass: "" }.merge!(options))
    end
  end
  
  #----------
  
  def comment_count_for(object, options={})
    if object.present? and object.respond_to?(:disqus_identifier)
      options[:class] = "comment_link social_disq #{options[:class]}"
      options["data-objkey"] = object.obj_key
      link_to( "Add your comments", object.link_path(anchor: "comments"), options )
    end
  end
  
  #----------
  
  def comments_for(object, options={})
    if object.present? && object.respond_to?(:disqus_identifier)
      render('shared/cwidgets/comments', { content: object, cssClass: "", header: true }.merge!(options))
    end
  end
  
  #----------
  
  def content_widget(partial, object, options={})
    partial = partial.chars.first == "/" ? partial : "shared/cwidgets/#{partial}"
    render(partial, { content: object, cssClass: "" }.merge!(options))
  end
  
  alias_method :widget, :content_widget
  
end
