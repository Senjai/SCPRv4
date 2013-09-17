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
  # This used the be the array of "classes that are content",
  # but we've since moved away from that concept.
  # Don't use it - just be explicit about which classes you
  # want to search across.
  CONTENT_CLASSES = [
    NewsStory,
    ShowSegment,
    BlogEntry,
    ContentShell
  ]

  #--------------------
  # URLS to match in ::obj_by_url
  CONTENT_MATCHES = {
    %r{\A/news/\d+/\d\d/\d\d/(\d+)/.*}                => 'NewsStory',
    %r{\A/blogs/[-_\w]+/\d+/\d\d/\d\d/(\d+)/.*}       => 'BlogEntry',
    %r{\A/programs/[\w_-]+/\d{4}/\d\d/\d\d/(\d+)/.*}  => 'ShowSegment'
  }


  def new_obj_key
    "contentbase:new"
  end

  #--------------------
  # Wrapper around ThinkingSphinx to just query all
  # ContentBase classes and mix in some default search
  # parameters.
  def search(*args)
    options     = args.extract_options!
    query       = args[0].to_s

    options.reverse_merge!({
      :classes     => CONTENT_CLASSES,
      :page        => 1,
      :order       => :public_datetime,
      :sort_mode   => :desc,
      :retry_stale => true,
      :populate    => true
    })

    # We'll want to search only among live content 99% of the
    # time. For the times when we want unpublished stuff,
    # we can pass in `with: { is_live: [true, false] }`, for
    # example.
    options[:with] ||= {}
    options[:with].reverse_merge!(is_live: true)

    begin
      ThinkingSphinx.search(query, options)
    rescue Riddle::ConnectionError, Riddle::ResponseError, ThinkingSphinx::SphinxError
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
  # Look to CONTENT_MATCHES to see if the passed-in URL
  # corresponds to any model.
  # Only find published articles.
  def obj_by_url(url)
    begin
      u = URI.parse(url)
    rescue URI::InvalidURIError
      return nil
    end

    if match = CONTENT_MATCHES.find { |k,_| u.path =~ k }
      # build the obj_key
      key       = match[1].constantize.obj_key($~[1])
      article   = Outpost.obj_by_key(key)
      article && article.published? ? article : nil
    else
      nil
    end
  end

  #---------------------
  # obj_by_url or raise
  def obj_by_url!(url)
    obj_by_url(url) or raise ActiveRecord::RecordNotFound
  end


  #--------------------
  # For drop-down menus in the CMS
  def status_text_collect
    STATUS_TEXT.map { |k, v| [v, k] }
  end
end # ContentBase
