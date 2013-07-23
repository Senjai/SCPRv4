# The NPR Importer is here because NPR, through their API, gives us more
# information about a given segment than an RSS feed does.
#
# A program with its source set to "npr-api" is assumed to have segmented
# episodes. This might not always be the case with the NPR API, I really 
# don't know, but we'll leave it like this until something breaks. For now
# we assume that every program has episodes, and every segment has an episode.
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
    # TODO: If there are more than 20 segments to an episode, need
    # to recognize that and do another query to fetch the other ones.
    # We can do this with pagination, using the startNum parameter.
    segments = NPR::Story.where(
      :id   => @external_program.external_id,
      :date => "current"
    ).limit(20).to_a

    # If there are no segments then forget about it.
    return false if segments.empty?

    # If there's not a show, then we should abort because the
    # imported segment will never get seen anyways, which would
    # be a hidden and potentially confusing bug.
    # If an episode with this air date for this program was already
    # imported, then it's safe to assume that we already imported its
    # segments as well. The NPR API specifies that requesting a 
    # program with `date=current` will only return COMPLETED episodes.
    show = segments.first.shows.last
    return false if !show || episode_exists?(show)

    external_episode = build_external_episode(show)

    segments.each do |segment|
      external_segment = build_external_segment(segment)

      external_episode.external_episode_segments.build(
        :external_segment => external_segment,
        :position         => show.segNum
      )
    end

    @external_program.save!
  end

  add_transaction_tracer :sync, category: :task



  private

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

  def build_external_segment(segment)
    @external_program.external_segments.build(
      :title              => segment.title,
      :teaser             => segment.teaser,
      :published_at       => segment.pubDate,
      :external_url       => segment.link_for("html"),
      :external_id        => segment.id,
      :external_program   => @external_program
    )
  end


  def episode_exists?(show)
    ExternalEpisode.exists?(
      :external_program_id    => @external_program.id,
      :air_date               => show.showDate
    )
  end

  def segment_exists?(segment)
    ExternalSegment.exists?(
      :external_program_id => @external_program.id,
      :external_id         => segment.id
    )
  end
end
