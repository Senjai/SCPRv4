# The NPR Importer is here because NPR, through their API, gives us more
# information about a given segment than an RSS feed does. With it, we're
# able to group segments together into episodes.
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
    @segments = NPR::Story.where(
      :id   => @external_program.external_id,
      :date => "current" 
    ).limit(20).to_a

    # If there are no segments then forget about it.
    return false if @segments.empty?

    if @external_program.is_episodic?
      sync_with_episode
    else
      sync_without_episode
    end
  end

  add_transaction_tracer :sync, category: :task



  private

  def sync_with_episode
    # If there is no show, or the program isn't episodic, then we can't
    # or shouldn't build an episode.
    if show = @segments.first.shows.last
      # If an episode with this air date for this program was already
      # imported, then it's safe to assume that we already imported its
      # segments as well. The NPR API specifies that requesting a 
      # program with `date=current` will only return COMPLETED episodes.
      return false if episode_exists?(show.showDate)

      external_episode = build_external_episode(show)

      @segments.each do |segment|
        external_segment = build_external_segment(segment)

        external_episode.external_episode_segments.build(
          :external_segment => external_segment,
          :position         => show.segNum
        )
      end

      @external_program.save!
    end
  end

  def sync_without_episode
    @segments.each do |segment|
      # If the external ID and the external program ID are the same,
      # then this is the same segment, and we don't have to create
      # it again.
      if !segment_exists?(segment.id)
        external_segment = build_external_segment(segment)
      end
    end

    @external_program.save!
  end


  def build_external_episode(show)
    @external_program.external_episodes.build(
      :title      => show.showDate.strftime("%A, %B %e, %Y"),
      :air_date   => show.showDate
    )
  end

  def build_external_segment(segment)
    @external_program.external_segments.build(
      :title              => segment.title,
      :teaser             => segment.teaser,
      :published_at       => segment.pubDate,
      :public_url         => segment.link_for("html"),
      :external_id        => segment.id,
      :external_program   => @external_program,
      :source             => SOURCE
    )
  end


  def episode_exists?(date)
    ExternalEpisode.exists?(
      :air_date               => date,
      :external_program_id    => @external_program.id
    )
  end

  def segment_exists?(segment_id)
    ExternalSegment.exists?(
      :external_id            => segment_id,
      :external_program_id    => @external_program.id,
      :source                 => SOURCE
    )
  end
end
