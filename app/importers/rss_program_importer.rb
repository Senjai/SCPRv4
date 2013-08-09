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

  # We're only going to bother with the first 5 episodes
  def sync
    feed = RSS::Parser.parse(@external_program.podcast_url, false)
    return false if !feed || feed.items.empty?

    feed.items.first(5).select { |i| can_import?(i) }.each do |item|
      episode = @external_program.external_episodes.build(
        :title       => item.title,
        :summary     => item.description,
        :air_date    => item.pubDate,
        :external_id => item.guid.content
      )

      # Import Audio
      enclosure = item.enclosure
      audio = Audio::DirectAudio.new(
        :external_url   => enclosure.url,
        :size           => enclosure.length,
        :description    => episode.title,
        :byline         => @external_program.title,
        :position       => 0
      )

      episode.audio << audio
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

  def can_import?(item)
    item.enclosure.present? &&
    item.enclosure.type =~ /audio/ &&
    !episode_exists?(item)
  end
end
