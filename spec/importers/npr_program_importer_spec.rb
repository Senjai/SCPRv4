require 'spec_helper'

describe NprProgramImporter do
  describe '::sync' do
    before :each do
      FakeWeb.register_uri(:get, %r{api\.npr\.org},
        :content_type   => 'application/json',
        :body           => load_fixture('api/npr/program.json')
      )
    end

    it "creates an episode" do
      external_program = create :external_program, :from_npr
      external_program.external_episodes.should be_empty

      NprProgramImporter.sync(external_program)

      external_program.external_episodes(true).count.should eq 1

      # From the JSON fixture:
      external_program.external_episodes.first.air_date.should eq Time.new(2013, 7, 15, 12)
    end

    it "sets the program on segments of episodes" do
      external_program = create :external_program, :from_npr
      NprProgramImporter.sync(external_program)
      external_program.external_segments.should_not be_empty
    end

    it "is false if segments is empty" do
      NPR::API::QueryBuilder.any_instance.stub(:to_a) { Array.new }

      external_program = create :external_program, :from_npr
      NprProgramImporter.sync(external_program).should eq false
      external_program.external_segments(true).should be_empty
    end

    it "is false if the episode already exists" do
      # Just load up the FakeWeb stub
      stories = NPR::Story.where(id: "current").to_a
      date = stories.first.shows.first.showDate

      external_program = create :external_program, :from_npr
      external_program.external_episodes.create(air_date: date)

      NprProgramImporter.sync(external_program).should eq false
      external_program.external_episodes(true).count.should eq 1
    end
  end
end
