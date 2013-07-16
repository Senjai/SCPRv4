module RssProgramImporter

  class << self
    include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation

    def sync(external_program)
      if external_program.podcast_url.present?
        import_entries(external_program.podcast_url)
      end

      if external_program.rss_url.present?
        import_entries(external_program.rss_url)
      end
    end

    add_transaction_tracer :sync, category: :task


    private

    def fetch_and_save_feed(url)
      Feedzirra::Feed.safe_fetch_and_parse(url) do |feed|

      end
    end
  end
end
