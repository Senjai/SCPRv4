require "spec_helper"

describe KpccProgram do
  describe "::scopes" do
    describe "can sync audio" do
      it "returns records with onair and audio_dir" do
        onair_and_dir = create :kpcc_program, air_status: "onair", audio_dir: "coolprogram"
        online        = create :kpcc_program, air_status: "online", audio_dir: "coolprogram"
        no_dir        = create :kpcc_program, air_status: "onair", audio_dir: ""
        offair_no_dir = create :kpcc_program, air_status: "online", audio_dir: ""

        KpccProgram.can_sync_audio.should eq [onair_and_dir]
      end
    end
  end

  describe "#absolute_audio_path" do
    it "is Audio::AUDIO_ROOT_PATH joined with the program's audio_dir" do
      stub_const("Audio::AUDIO_PATH_ROOT", "/home/path/to/audio")
      program = create :kpcc_program, audio_dir: "someshow"
      program.absolute_audio_path.should eq "/home/path/to/audio/someshow"
    end

    it "is nil if audio_dir is present" do
      program = create :kpcc_program, audio_dir: nil
      program.absolute_audio_path.should eq nil
    end
  end

  describe '#to_program' do
    it 'turns it into a program' do
      program = build :kpcc_program
      program.to_program.should be_a Program
    end
  end

  describe 'slug uniqueness validation' do
    it 'validates that the slug is unique across the program models' do
      external_program = create :external_program, slug: "same"
      kpcc_program = build :kpcc_program, slug: "same"
      kpcc_program.should_not be_valid
      kpcc_program.errors[:slug].first.should match /be unique between/
    end
  end
end
