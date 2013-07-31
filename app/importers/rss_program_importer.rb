require 'rss'

# We assume that the RSS feeds (podcast) contain an entire episode in each
# item. I don't know if this is always necessarily true.
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
    feed = RSS::Parser.parse(@external_program.podcast_url, false)
    return false if !feed || feed.items.empty?

    feed.items.first(5).reject { |e| episode_exists?(e) }.each do |item|
      @external_program.external_episodes.build(
        :title       => item.title,
        :summary     => item.description,
        :air_date    => item.pubDate,
        :external_id => item.guid.content
      )
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
