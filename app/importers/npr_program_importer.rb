# The NPR Importer is here because NPR, through their API, gives us more
# information about a given segment than an RSS feed does.
#
# A program with its source set to "npr-api" is assumed to have segmented
# episodes. This might not always be the case with the NPR API, I really 
# don't know, but we'll leave it like this until something breaks. For now
# we assume that every program has episodes, and every segment has an episode.
#
# We are also assuming that all segments in an episode will have audio.
# 
# http://www.npr.org/api/mappingCodes.php
class NprProgramImporter
  include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation
  SOURCE = "npr-api"


  class << self
    def sync(external_program)
      self.new(external_program).sync
    end
  end



  def initialize(external_program)
    @external_program = external_program
  end


  def sync
    # `date=current` returns the program's latest episode's segments.
    # Set limit to 20 to return as many segments as possible for the
    # episode.
    stories   = []
    offset    = 0

    begin
      response = fetch_stories(offset)
      stories += response
      offset += 20
    end until response.size < 20

    # If there are no segments then forget about it.
    # Even if an episode is available in the NPR API, its audio may 
    # not be available yet. If there is a single story in the response
    # which *doesn't* yet have audio, then we will abort importing and
    # get it next time.
    return false if stories.empty? || !audio_available?(stories)

    # If there's not a show, then we should abort because the
    # imported segment will never get seen anyways, which would
    # be a hidden and potentially confusing bug.
    # If an episode with this air date for this program was already
    # imported, then it's safe to assume that we already imported its
    # segments as well. The NPR API specifies that requesting a 
    # program with `date=current` will only return COMPLETED episodes.
    #
    # If there are segments with their "stream" permission set to "false",
    # then we'll go ahead with the sync, but just won't import those ones.
    show = stories.first.shows.last
    return false if !show || episode_exists?(show)

    external_episode = build_external_episode(show)

    stories.each do |story|
      external_segment = build_external_segment(story)
      external_episode.external_episode_segments.build(
        :external_segment => external_segment,
        :position         => story.shows.last.segNum
      )

      # Bring in Audio
      # Note that NPR doesn't provide Audio for its full episodes,
      # only segmented audio.
      story.audio.select { |a| stream_allowed?(a) }
      .each_with_index do |remote_audio, i|
        if mp3 = remote_audio.formats.mp3s.find { |m| m.type == "mp3" }
          local_audio = Audio::DirectAudio.new(
            :external_url   => mp3.content,
            :duration       => remote_audio.duration,
            :description    => remote_audio.description ||
                               remote_audio.title ||
                               story.title,
            :byline         => remote_audio.rightsHolder || "NPR",
            :position       => i
          )

          external_segment.audio << local_audio
        end
      end
    end

    @external_program.save!
  end

  add_transaction_tracer :sync, category: :task



  private

  def fetch_stories(offset)
    NPR::Story.where(
      :id   => @external_program.external_id,
      :date => "current"
    ).set(requiredAssets: "audio")
    .limit(20).offset(offset)
    .to_a.select { |s| can_stream?(s) }
  end

  # For NPR, we kind of have to make-up these episodes, since NPR
  # doesn't really keep track of the shows, except for the air-date
  # and as a means to group together segments.
  def build_external_episode(show)
    @external_program.external_episodes.build(
      :title      => "#{@external_program.title} for " +
                     show.showDate.strftime("%A, %B %e, %Y"),
      :air_date   => show.showDate
    )
  end

  def build_external_segment(story)
    @external_program.external_segments.build(
      :title              => story.title,
      :teaser             => story.teaser,
      :published_at       => story.pubDate,
      :external_url       => story.link_for("html"),
      :external_id        => story.id,
      :external_program   => @external_program
    )
  end


  def episode_exists?(show)
    ExternalEpisode.exists?(
      :external_program_id    => @external_program.id,
      :air_date               => show.showDate
    )
  end

  def can_stream?(story)
    story.audio.any? { |a| stream_allowed?(a) }
  end

  def stream_allowed?(audio)
    audio.permissions.stream?
  end

  def audio_available?(stories)
    stories.all? { |story|
      story.audio.present? &&
      story.audio.all? { |a| !a.formats.empty? }
    }
  end
end
