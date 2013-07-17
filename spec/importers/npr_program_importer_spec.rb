require 'spec_helper'

describe NprProgramImporter do
  describe '::sync' do
    before :each do
      FakeWeb.register_uri(:get, %r{api\.npr\.org},
        :content_type   => 'application/json',
        :body           => load_fixture('api/npr/program.json')
      )
    end

    it "creates an episode for an episodic program" do
      external_program = create :external_program, :from_npr, is_episodic: true
      external_program.external_episodes.should be_empty

      NprProgramImporter.sync(external_program)

      external_program.external_episodes(true).count.should eq 1

      # From the JSON fixture:
      external_program.external_episodes.first.air_date.should eq Time.new(2013, 7, 15, 12)
    end

    it "does not create an episode if the program is not episodic" do
      
    end
  end
end
