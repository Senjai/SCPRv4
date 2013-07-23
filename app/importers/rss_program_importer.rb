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

  def sync
    Feedzirra::Feed.safe_fetch_and_parse(url) do |feed|
      feed.entries.each do |entry|
        @external_program.external_episodes.build(
          :title      => entry.title,
          :air_date   => entry.published
        )
      end
    end
  end

  add_transaction_tracer :sync, category: :task
end
