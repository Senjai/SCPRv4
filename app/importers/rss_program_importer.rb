# We look to the program's `feed_type` attribute to find out what we're
# importing. Without this, we can't really know for sure whether each
# RSS/podcast entry is a full episode (like BBC or Prarie Home Companion)
# or a segment of an episode (Science Friday, Morning Edition).
#
#   
module RssProgramImporter
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
    feed = Feedzirra::Feed.safe_fetch_and_parse(url)

    if @external_program.feed_type == "rss-episodes"
      feed.entries.first(5).reject { |e| episode_exists?(e) }.each do |entry|
        @external_program.external_episodes.build(
          :title       => entry.title,
          :summary     => entry.summary,
          :air_date    => entry.published,
          :external_id => entry.entry_id
        )
      end

    elsif @external_program.feed_type == "rss-segments"
      feed.entries.first(20).reject { |e| segment_exists?(e) }.each do |entry|
        @external_program.external_segments.build(
          :title          => entry.title,
          :teaser         => entry.summary,
          :published_at   => entry.published,
          :external_id    => entry.entry_id,
          :external_url   => entry.url
        )
      end
    end

    @external_program.save!
  end

  add_transaction_tracer :sync, category: :task


  private

  def episode_exists?(entry)
    ExternalEpisode.exists?(
      :external_program_id    => @external_program.id,
      :external_id            => entry.entry_id
    )
  end

  def segment_exists?(entry)
    ExternalSegment.exists?(
      :external_program_id    => @external_program.id,
      :external_id            => entry.entry_id
    )
  end
end
