require "spec_helper"

describe KpccProgram do
  describe "associations" do
    it { should have_many :segments }
    it { should have_many :episodes }
    it { should have_many :schedules }
    it { should belong_to :missed_it_bucket }
    it { should belong_to :blog }
  end
  
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
