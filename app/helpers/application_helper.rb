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
    return '' if content.blank?

    html = ''
    
    Array(content).compact.each do |c|
      if c.respond_to?(:content)
        next if c.content.blank?
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
      html << render(options.merge({
        :partial    => "shared/content/#{partial}",
        :object     => c,
        :as         => :content
      }))
    end
    
    html.html_safe
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
  def render_asset(content, context, fallback=false)
    if content.blank? || !content.respond_to?(:assets)
      return ''
    end

    if content.assets.blank?
      return fallback ? render("shared/assets/#{context}/fallback", content: content) : ''
    end
    
    # look for a scheme on the content object
    attribute = "#{context}_asset_scheme"
    scheme = content.respond_to?(attribute) ? content.send(attribute) : "default"

    # set up our template precendence
    tmplt_opts = [
      "#{context}/#{scheme}",
      "default/#{scheme}",
      "#{context}/default",
      "default/default"
    ]
    
    partial = tmplt_opts.detect { |t| self.lookup_context.exists?(t,["shared/assets"],true) }

    render "shared/assets/#{partial}", assets: content.assets, content: content
  end
  
  #----------
  
  def is_vertical?(asset)
    asset.height.to_i > asset.width.to_i
  end
  
  #----------
  
  def random_headshot
    images = ["stoltze.png", "peterson.png", "moore.png", "guzman-lopez.png", "julian.png", "watt.png", "oneil.png", "trujillo.png"]
    image_tag "personalities/#{images.sample}"
  end
  
  #----------
  
  def smart_date_js(datetime, options={})
    return '' if !datetime.respond_to?(:strftime)

    time_tag datetime, '', {
      "class"         => "#{options[:class]} smart smarttime", 
      "data-unixtime" => datetime.to_i
    }.merge(options.except(:class))
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
        link_to byline.display_name, byline.user.public_path
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
      :classes     => [NewsStory, BlogEntry, ShowSegment, ContentShell],
      :limit       => 12,
      :with        => { 
        :category_is_news => false,
        :is_live          => true
      },
      :without     => { category: '' }
    })
  end
  
  #----------
  
  def get_latest_news
    ContentBase.search({
      :classes     => [NewsStory, BlogEntry, ShowSegment, ContentShell],
      :limit       => 12,
      :with        => { 
        :category_is_news => true,
        :is_live          => true
      }
    })
  end
  
  #----------
  
  def link_to_audio(title, object, options={}) # This needs to be more useful
    options[:class] = "audio-toggler #{options[:class]}"
    options[:title] ||= object.short_headline
    options["data-duration"] = object.audio.available.first.duration
    content_tag :div, link_to(title, object.audio.available.first.url, options), class: "story-audio inline"
  end
  
  #---------------------------

  def twitter_profile_url(handle)
    "http://twitter.com/#{handle.parameterize}"
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

  #----------
  
  def pij_source(content, options={})
    message = options[:message] || "This story was informed by KPCC listeners."

    if content.is_from_pij?
      render '/shared/cwidgets/pij_notice', message: message
    end
  end

  #----------
  # Render a timestamp inside of a time tag.
  #
  # time_tag uses i18n's `localize` method, which raises
  # if the date passed in doesn't respond to strftime, so we 
  # need to check that this is the case before rendering the
  # time tag. Otherwise previewing unpublished content breaks.
  def timestamp(datetime)
    if datetime.respond_to?(:strftime)
      time_tag datetime, format_date(datetime, format: :full_date, time: true), pubdate: true
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
      link_to( "Add your comments", object.public_path(anchor: "comments"), options )
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
  
  #---------------
  # These two methods are taken from EscapeUtils
  def html_escape(string)
    EscapeUtils.escape_html(string.to_s).html_safe
  end
  alias_method :h, :html_escape

  def url_encode(s)
    EscapeUtils.escape_url(s.to_s).html_safe
  end
  alias_method :u, :url_encode
end
