require 'spec_helper'

describe NprProgramImporter do
  describe '::sync' do
    context 'with available audio' do
      before :each do
        stub_request(:get, %r{api\.npr\.org}).to_return({
          :content_type   => 'application/json',
          :body           => load_fixture('api/npr/program.json')
        })
      end

      it "requests more if there are 20 stories in the initial response" do
        stub_request(:get, %r{api\.npr\.org/.+startNum=1}).to_return({
          :content_type   => 'application/json',
          :body           => load_fixture('api/npr/program_pg1.json')
        })

        stub_request(:get, %r{api\.npr\.org/.+startNum=21}).to_return({
          :content_type   => 'application/json',
          :body           => load_fixture('api/npr/program_pg2.json')
        })

        external_program = create :external_program, :from_npr
        external_program.external_segments.should be_empty

        NprProgramImporter.sync(external_program)

        external_program.external_segments.count.should eq 21
      end

      it "creates an episode" do
        external_program = create :external_program, :from_npr
        external_program.external_episodes.should be_empty

        NprProgramImporter.sync(external_program)

        external_program.external_episodes(true).count.should eq 1

        # From the JSON fixture:
        external_program.external_episodes.first.air_date.should eq Time.new(2013, 7, 15, 12)
      end

      it "adds in audio if it's available" do
        external_program = create :external_program, :from_npr
        NprProgramImporter.sync(external_program)

        external_program.external_episodes.first.
        external_segments.first.
        audio.first.url.should eq "http://pd.npr.org/anon.npr-mp3/npr/atc/2013/07/20130715_atc_02.mp3?orgId=1&topicId=1015&ft=3&f=2"
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
        # Just load up the stub
        stories = NPR::Story.where(id: "current").to_a
        date = stories.first.shows.first.showDate

        external_program = create :external_program, :from_npr
        external_program.external_episodes.create(air_date: date)

        NprProgramImporter.sync(external_program).should eq false
        external_program.external_episodes(true).count.should eq 1
      end
    end

    context 'without available audio' do
      it "doesn't import the episode if the audio isn't available" do
        stub_request(:get, %r{api\.npr\.org}).to_return({
          :content_type => 'application/json',
          :body => load_fixture('api/npr/program_audio_unavailable.json')
        })

        external_program = create :external_program, :from_npr
        NprProgramImporter.sync(external_program)
        external_program.external_episodes(true).count.should eq 0
      end

      it "doesn't import the episode if the audio doesn't grant stream permissions" do
        stub_request(:get, %r{api\.npr\.org}).to_return({
          :content_type => 'application/json',
          :body => load_fixture('api/npr/program_audio_nostream.json')
        })

        external_program = create :external_program, :from_npr
        NprProgramImporter.sync(external_program)
        external_program.external_episodes(true).count.should eq 0
      end
    end
  end
end
