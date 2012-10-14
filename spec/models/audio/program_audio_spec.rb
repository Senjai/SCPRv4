require "spec_helper"

describe Audio::ProgramAudio do
  describe "callbacks" do
    describe "#set_description_to_episode_headline" do
      let(:content) { create :show_episode, headline: "Cool Episode, Bro", show: create(:kpcc_program, audio_dir: "coolshow") }
    
      it "sets description to content's headline before create if description is blank" do
        audio = create :program_audio, description: nil, content: content
        audio.description.should eq "Cool Episode, Bro"
      
        # Make sure it doesn't happen on subsequent saves
        content.update_attribute(:headline, "Cooler Story")
        audio.save
        audio.reload.description.should eq "Cool Episode, Bro"
      end
    
      it "doesn't run if the description was given" do
        audio = create :program_audio, description: "Cool Audio, Bro", content: content
        audio.description.should eq "Cool Audio, Bro"
      end
    end
  end

  #----------------
  
  describe "::filename" do
    it "is the mp3's actual filename" do
      audio = build :audio, :program, :for_episode
      Audio::ProgramAudio.filename(audio).should eq "20121002_mbrand.mp3"
    end
  end
  
  #----------------
  
  describe "::store_dir" do
    it "is the show's audio_dir" do
      audio = build :audio, :program, :for_segment
      audio.content.show.update_attribute(:audio_dir, "coolshowbro")
      Audio::ProgramAudio.store_dir(audio).should eq "coolshowbro"
    end
  end
  
  #----------------
  
  describe "::bulk_sync!" do
    let(:program) { create :kpcc_program, display_episodes: true, audio_dir: "coolshowbro", air_status: "onair" }

    before :each do
      # October 02, 2012 is the date on the fixture mp3 file
      episode = create :show_episode, air_date: Chronic.parse("October 02, 2012"), show: program
      segment = create :show_segment, :published, published_at: Chronic.parse("October 02, 2012"), show: program
      KpccProgram.can_sync_audio.count.should eq 1
    end
    
    context "doesn't sync" do
      it "if file has already been synced in database" do
        Audio::ProgramAudio.stub(:existing) { { "mbrand/20121002_mbrand.mp3" => true } }
        File.should_not_receive(:mtime)
        Audio::ProgramAudio.bulk_sync!.should eq []
      end
    
      it "if filename doesn't match the regex" do
        Audio::ProgramAudio.stub(:existing) { { } }
        Dir.should_receive(:[]).with(program.absolute_audio_path).and_return(["nomatch.mp3"])
        File.should_not_receive(:mtime)
        Audio::ProgramAudio.bulk_sync!.should eq []
      end
    
      it "if file mtime is too old" do
        Audio::ProgramAudio.stub(:existing) { { } }
        Dir.should_receive(:[]).with(program.absolute_audio_path).and_return(["20121002_mbrand.mp3"])
        File.should_receive(:mtime).with(File.join Audio::AUDIO_PATH_ROOT, "coolshowbro/20121002_mbrand.mp3").and_return(1.month.ago)
        Audio::ProgramAudio.bulk_sync!.should eq []
      end
    end
    
    context "syncs" do
      before :each do
        Audio::ProgramAudio.instance_variable_set(:@synced, nil)
      end
      
      it "if all the criteria pass for episodes" do
        Audio::ProgramAudio.stub(:existing) { { } } # Not existing
        Dir.should_receive(:[]).with(program.absolute_audio_path).and_return(["20121002_mbrand.mp3"]) # Filename matches
        File.should_receive(:mtime).with(File.join Audio::AUDIO_PATH_ROOT, "coolshowbro/20121002_mbrand.mp3").and_return(Time.now) # File new

        audio = build :program_audio, content: program.episodes.first
        Audio::ProgramAudio.should_receive(:new).and_return(audio)
        Audio::ProgramAudio.bulk_sync!.should eq [audio]
      end
    
      it "if all the criteria pass for segments" do
        Audio::ProgramAudio.stub(:existing) { { } } # Not existing
        Dir.should_receive(:[]).with(program.absolute_audio_path).and_return(["20121002_mbrand.mp3"]) # Filename matches
        File.should_receive(:mtime).with(File.join Audio::AUDIO_PATH_ROOT, "coolshowbro/20121002_mbrand.mp3").and_return(Time.now) # File new

        audio = build :program_audio, content: program.segments.first
        Audio::ProgramAudio.should_receive(:new).and_return(audio)
        Audio::ProgramAudio.bulk_sync!.should eq [audio]
      end
    end
  end
end
