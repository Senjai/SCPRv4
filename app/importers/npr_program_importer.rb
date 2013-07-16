# http://www.npr.org/api/mappingCodes.php
module NprProgramImporter

  SOURCE = "npr-api"


  class << self
    include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation

    def sync(external_program)
      # `date=current` returns the program's latest episode's segments.
      # Set limit to 20 to return as many segments as possible for the
      # episode.
      # TODO: If there are more than 20 segments to an episode, need
      # to recognize that and do another query to fetch the other ones.
      # We can do this with pagination, using the startNum parameter.
      segments = Npr::Story.where(
        :id   => external_program.remote_id,
        :date => "current" 
      ).limit(20).to_a

      # If there are no segments then forget about it.
      return false if segments.empty?

      show = segments.first.shows.first
      episode = nil

      # If there is no show, or the program isn't episodic, then we can't
      # or shouldn't build an episode.
      if show && external_program.is_episodic?
        # If an episode with this air date for this program was already
        # imported, then it's safe to assume that we already imported its
        # segments as well. The NPR API specifies that requesting a 
        # program with `date=current` will only return COMPLETED episodes.
        return false if ExternalEpisode.exists?(
          :air_date               => show.showDate,
          :source                 => SOURCE,
          :external_program_id    => external_program.id
        )

        episode = ExternalEpisode.new(
          :title              => show.showDate.strftime("%A, %B %e, %Y"),
          :air_date           => show.showDate,
          :source             => SOURCE,
          :external_program   => external_program
        )
      end

      segments.each do |segment|
        # If the external ID and the external program ID are the same,
        # then this is the same segment, and we can ignore it.
        if !ExternalSegment.exists?(
          :external_id    => segment.id,
          :source         => SOURCE
        )

          ExternalSegment.create(
            :title          => segment.title,
            :teaser         => segment.teaser,
            :published_at   => segment.pubDate,
            :external_url   => segment.link_for("html"),
            :external_id    => segment.id,
            :source         => SOURCE
          )
        end
      end
    end

    add_transaction_tracer :sync, category: :task
  end
end
