require "spec_helper"

describe KpccProgram do
  
  #--------------------

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:slug) }
    it { should validate_presence_of(:air_status) }
    
    it "validates slug uniqueness" do
      create :kpcc_program
      should validate_uniqueness_of(:slug)
    end    
  end
  
  #--------------------

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
  
  #--------------------
  
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
end
