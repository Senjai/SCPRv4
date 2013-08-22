# abstract (noun) - a summary of a text, scientific article, document, 
# speech, etc.
#
# Abstract is basically a summary of an article.
# It was created to be used with the Edition model, and to be
# presented from within the mobile application, but there is
# no reason that it couldn't also be used on the website
# if there was a place for it.
#
# "How is this different from a ContentShell?". 
# I'm glad you asked.
#
# A ContentShell is really just a reference, or pointer, to a 
# remote source. It isn't content, although it does show up in 
# the normal rotation of Content (among news stories and blog 
# posts). Rather, it is an anchor to another website, and is 
# intended to be clicked 100% of the time. A ContentShell
# is a teaser to someone else's work.
#
# An Abstract is similar, no doubt. However, it has some key 
# differences. It is meant to summarize an article. It is not
# expected to produce clickthroughs - the idea is that someone
# could read the summary of an Abstract, or listen to its audio,
# and feel adequately informed - only those who are really 
# interested in the details will click through to the remote 
# article. An Abstract is substantive and could have its own
# landing page on our website.
# 
# 
# "How is this different, then, from a NewsStory?"
# Jeez, you ask a lot of questions.
#
# A NewsStory is *more* substantial than an Abstract. It has 
# several paragraphs of body copy, and is meant to be read fully.
# There can be Abstracts for our NewsStories.
#
# So, think of an Abstract as being somewhere between ContentShell
# and NewsStory. Sort of.
#
#
# "But couldn't we just-"
# No. We're done here.
#
class Abstract < ActiveRecord::Base
  outpost_model
  has_secretary

  include Concern::Associations::AssetAssociation
  include Concern::Associations::CategoryAssociation
  include Concern::Associations::AudioAssociation
  include Concern::Associations::EditionsAssociation
  include Concern::Callbacks::SphinxIndexCallback
  include Concern::Callbacks::TouchCallback

  validates :source, presence: true
  validates :url, presence: true, url: true
  validates :headline, presence: true
  validates :summary, presence: true


  define_index do
    indexes headline
    indexes summary
    indexes url
    has :source
    has category.id, as: :category
    has updated_at
    has article_published_at

    # For ContentBase.search
    has created_at, as: :public_datetime
    has "1", as: :is_live, type: :boolean
  end

  attr_accessor :original_object

  class << self
    def sources_select_collection
      Abstract.select("distinct source").order("source").map(&:source)
    end
  end


  # Currently, Abstracts will only be publicly available 
  # through Editions, and there is therefore no need for us
  # to have "publish status" on them. If we ever want to 
  # use Abstracts outside of Editions, then we will probably
  # need to add that capability. For now, "published?" is just
  # always true, and the objects don't have a status or 
  # published_at fields.
  def published?
    true
  end


  def to_article
    @to_article ||= Article.new({
      :original_object    => self,
      :id                 => self.obj_key,
      :title              => self.headline,
      :short_title        => self.headline,
      :public_datetime    => self.created_at,
      :category           => self.category,
      :teaser             => self.summary,
      :body               => self.summary,
      :assets             => self.assets,
      :audio              => self.audio.available,
      :byline             => self.source,
      :edit_url           => self.admin_edit_url
    })
  end

  def to_abstract
    self
  end
end
