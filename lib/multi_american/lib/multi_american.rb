$: << "."

module WP
  BLOG_ID = 22 # For Multi-American
  BLOG_SLUG = 'multi-american'
  CONTENT_TYPE_ID = 44 # BlogEntry (in mercer)
  
  POST_DEFAULTS = {
    blog_id:      WP::BLOG_ID,
    blog_slug:    WP::BLOG_SLUG,
    is_published: 0
  }
end

require 'multi_american/lib/multi_american/document.rb'
require 'multi_american/lib/multi_american/node.rb'

require 'multi_american/lib/multi_american/post.rb'
require 'multi_american/lib/multi_american/jiffy_post.rb'
require 'multi_american/lib/multi_american/attachment.rb'
require 'multi_american/lib/multi_american/nav_menu_item.rb'
require 'multi_american/lib/multi_american/roundup.rb'
require 'multi_american/lib/multi_american/topic.rb'

require 'multi_american/lib/multi_american/author.rb'
require 'multi_american/lib/multi_american/tag.rb'

# Setup our resources based on WP classes and remove ones we don't
# want listed.
ignores = %w{documents nodes}
WP::RESOURCES = WP.constants.select { |c| WP.const_get(c).is_a? Class }
                            .map { |r| r.to_s.demodulize.underscore.pluralize } - ignores
