require 'rss'

# We look to the program's `feed_type` attribute to find out what we're
# importing. Without this, we can't really know for sure whether each
# RSS/podcast entry is a full episode (like BBC or Prarie Home Companion)
# or a segment of an episode (Science Friday, Morning Edition).
#
#   
class RssProgramImporter
  include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation


  class << self
    def sync(external_program)
      self.new(external_program).sync
    end
  end


  def initialize(external_program)
    @external_program = external_program
  end

  # We're only going to bother with the first 20 segments,
  # because some feeds could have thousands of entries.
  def sync
    feed = RSS::Parser.parse(@external_program.rss_url)
    return false if !feed || feed.items.empty?

    if @external_program.feed_type == "rss-episodes"
      feed.items.first(5).reject { |e| episode_exists?(e) }.each do |item|
        @external_program.external_episodes.build(
          :title       => item.title,
          :summary     => item.description,
          :air_date    => item.pubDate,
          :external_id => item.guid.content
        )
      end

    elsif @external_program.feed_type == "rss-segments"
      feed.items.first(20).reject { |e| segment_exists?(e) }.each do |item|
        @external_program.external_segments.build(
          :title          => item.title,
          :teaser         => item.description,
          :published_at   => item.pubDate,
          :external_id    => item.guid.content,
          :external_url   => item.link
        )
      end
    end

    @external_program.save!
  end

  add_transaction_tracer :sync, category: :task


  private

  def episode_exists?(item)
    ExternalEpisode.exists?(
      :external_program_id    => @external_program.id,
      :external_id            => item.guid.content
    )
  end

  def segment_exists?(item)
    ExternalSegment.exists?(
      :external_program_id    => @external_program.id,
      :external_id            => item.guid.content
    )
  end
end
