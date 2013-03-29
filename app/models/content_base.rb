##
# ContentBase
#
# A set of definitions, collections, and utilities for
# content in the application.
#
module ContentBase
  extend self
  
  #--------------------
  # Status definitions
  # Always use these - don't hard-code the
  # status numbers.
  STATUS_KILLED   = -1
  STATUS_DRAFT    = 0
  STATUS_REWORK   = 1
  STATUS_EDIT     = 2
  STATUS_PENDING  = 3
  STATUS_LIVE     = 5
  
  STATUS_TEXT = {
      STATUS_KILLED   => "Killed",
      STATUS_DRAFT    => "Draft",
      STATUS_REWORK   => "Awaiting Rework",
      STATUS_EDIT     => "Awaiting Edits",
      STATUS_PENDING  => "Pending",
      STATUS_LIVE     => "Published"
  }
  
  #--------------------
  # The classes to be included when querying Sphinx with
  # ContentBase.search. These classes need to all have 
  # the same attributes and indexes in their +define_index+
  # block.
  CONTENT_CLASSES = [
    NewsStory,
    ShowSegment,
    ShowEpisode,
    BlogEntry,
    VideoShell,
    ContentShell
  ]
  
  #--------------------
  # URLS to match in ::obj_by_url
  CONTENT_MATCHES = {
    %r{\A/news/\d+/\d\d/\d\d/(\d+)/.*}                => 'NewsStory',
    %r{\A/blogs/[-_\w]+/\d+/\d\d/\d\d/(\d+)/.*}       => 'BlogEntry',
    %r{\A/programs/[\w_-]+/\d{4}/\d\d/\d\d/(\d+)/.*}  => 'ShowSegment',
    %r{\A/video/(\d+)/.*}                             => 'VideoShell',
  }

  OBJ_KEY_REGEX = %r{([^:]+):(\d+)}

  #--------------------
  # Wrapper around ThinkingSphinx to just query all
  # ContentBase classes and mix in some default search
  # parameters.
  def search(*args)
    options = args.extract_options!
    query   = args[0].to_s
    
    default_attributes = { status: ContentBase::STATUS_LIVE, findable: true }
    
    options.reverse_merge!({
      :classes     => CONTENT_CLASSES,
      :page        => 1,
      :order       => :published_at,
      :sort_mode   => :desc,
      :retry_stale => true,
      :populate    => true
    })
    
    if options[:with].present?
      options[:with].reverse_merge! default_attributes
    else
      options[:with] = default_attributes
    end

    begin
      ThinkingSphinx.search(query, options)
    rescue Riddle::ConnectionError, ThinkingSphinx::SphinxError
      # In this one scenario, we need to fail gracefully from a Sphinx error,
      # because otherwise the entire website will be down if media isn't available,
      # or if we need to stop the searchd daemon for some reason, like a rebuild.
      Kaminari.paginate_array([]).page(0).per(0)
    end
  end

  #--------------------
  # Generate a teaser from the passed-in text.
  # If the text is blank, return an empty string.
  # If the first paragraph is <= target length, return the first paragraph.
  # Otherwise get everything up to the target length, the up to the next period.
  def generate_teaser(text, length=180)
    return '' if text.blank?
    teaser = ''

    stripped_body = ActionController::Base.helpers.strip_tags(text)
      .gsub("&nbsp;"," ").gsub(/\r/,'').strip

    stripped_body.match(/^.+/) do |match|
      first_paragraph = match[0]

      if first_paragraph.length <= length
        teaser = first_paragraph
      else
        shortened_paragraph = first_paragraph.match(/\A.{#{length}}[^\.]*\.?/)
        teaser = shortened_paragraph ? "#{shortened_paragraph[0]}" : first_paragraph
      end
    end

    teaser
  end

  #--------------------
  # Convert key from "app/model:id" to AppModel
  def get_model_for_obj_key(key)
    match = match_key(key)
    model_classes[match[1]] if match
  end

  #--------------------
  # Convert key from "app/model:id" to AppModel.find_by_id(id)
  def obj_by_key(key)
    if match = match_key(key)
      model = model_classes[match[1]]
      model.find_by_id(match[2]) if model
    end
  end

  #--------------------
  # Same as #obj_by_key, but raises ActiveRecord::RecordNotFound
  # if no object is found or if key doesn't match.
  def obj_by_key!(key)
    obj_by_key(key) or raise ActiveRecord::RecordNotFound
  end
  
  #--------------------
  # Look to CONTENT_MATCHES to see if the passed-in URL
  # corresponds to any model.
  def obj_by_url(url)
    begin
      u = URI.parse(url)
    rescue URI::InvalidURIError
      return nil
    end
    
    if match = CONTENT_MATCHES.find { |k,_| u.path =~ k }
      key = [match[1].constantize.content_key, $~[1]].join(":")
      self.obj_by_key(key)
    end
  end
  
  #--------------------
  # For drop-down menus in the CMS
  def status_text_collect
    ContentBase::STATUS_TEXT.map { |p| [p[1], p[0]] }
  end

  #--------------------
  
  private
  
  def match_key(key)
    key.to_s.match(OBJ_KEY_REGEX)
  end

  #--------------------
  
  def model_classes
    klasses = {}
    
    Outpost.config.registered_models.each do |name|
      klass = name.constantize
      klasses.merge!(klass.content_key => klass)
    end
    
    klasses
  end
end # ContentBase
