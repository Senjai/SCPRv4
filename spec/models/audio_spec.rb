require "spec_helper"

describe Audio do
  describe "associations" do
    it { should belong_to(:content) }
  end


  #----------------
  #----------------
  
  describe "validations" do
    context "#enco_info_is_present_together" do
      it "runs on save" do
        audio = build :audio, :enco
        audio.should_receive(:enco_info_is_present_together).once
        audio.save!
      end
      
      it "fails if enco_number present but not enco_date" do
        audio = build :audio, enco_date: nil, enco_number: 999
        audio.enco_info_is_present_together
        audio.errors.keys.should eq [:base, :enco_number, :enco_date]
      end
    
      it "fails if enco_date present but not enco_number" do
        audio = build :audio, enco_date: Date.today, enco_number: nil
        audio.enco_info_is_present_together
        audio.errors.keys.should eq [:base, :enco_number, :enco_date]
      end
    
      it "passes if enco_date and enco_number are present" do
        audio = build :audio, enco_date: Date.today, enco_number: 999
        audio.enco_info_is_present_together
        audio.errors.should be_blank
      end
    
      it "passes if neither enco_date nor enco_number were provided" do
        audio = build :audio, :direct, enco_date: nil, enco_number: nil
        audio.enco_info_is_present_together
        audio.errors.should be_blank
      end
    end
    
    #----------------
    
    context "#audio_source_is_provided" do
      it "runs on save" do
        audio = build :audio, :enco
        audio.should_receive(:audio_source_is_provided).once
        audio.save!
      end
      
      it "is valid if only enco_number and enco_date present" do
        audio = build :audio, :enco, mp3_path: nil, mp3: nil
        audio.audio_source_is_provided
        audio.errors.should be_blank
      end
      
      it "is valid if only mp3_path present" do
        audio = build :audio, :direct, enco_number: nil, enco_date: nil, mp3: nil
        audio.audio_source_is_provided
        audio.errors.should be_blank
      end
      
      it "is valid if only mp3 present" do
        audio = build :audio, :uploaded, mp3_path: nil, enco_number: nil, enco_date: nil
        audio.save
        audio.errors.should be_blank
      end
      
      it "is invalid if everything is blank" do
        audio = build :audio, mp3: nil, mp3_path: nil, enco_number: nil, enco_date: nil
        audio.audio_source_is_provided
        audio.errors.keys.should eq [:base]
      end
    end
    
    #----------------
    
    context "#mp3_exists" do
      it "runs on save for existing records" do
        audio = create :audio, :enco
        audio.should_receive(:mp3_exists).once
        audio.save!
      end

      it "does not run on create" do
        audio = build :audio, :enco
        audio.should_not_receive(:mp3_exists)
        audio.save!
      end
      
      it "is valid if the audio actually exists on the filesystem" do
        audio = build :audio, :uploaded
        File.open audio.mp3.file.path # make sure it exists
        audio.mp3_exists
        audio.errors.should be_blank
      end
      
      it "is invalid if the audio doesn't exist on the filesystem" do
        audio = create :audio, :uploaded
        -> { File.open audio.mp3.file.path }.should_not raise_error Errno::ENOENT
        `rm -rf #{Rails.application.config.scpr.media_root}/audio/upload/#{Time.now.strftime("%Y/%m/%d")}`
        -> { File.open audio.mp3.file.path }.should raise_error Errno::ENOENT # make sure it *doesn't* exist
        audio.reload
        audio.mp3_exists
        audio.errors.keys.should eq [:mp3]        
      end
      
      it "ignores this validation if the environment is development" do
        audio = build :audio, :uploaded
        audio.should_not_receive(:mp3_exists)
        Rails.stub(:env) { "development" }
        audio.save!
      end
    end
  end
  
  
  #----------------
  #----------------
  
  describe "scopes" do
    describe "::available" do
      it "selects only audio objects with mp3 present" do
        available   = create :audio, :uploaded
        unavailable = create :audio, :enco # mp3 is blank
        Audio.available.should eq [available.becomes(Audio::UploadedAudio)]
      end
    end

    #----------------
    
    describe "::awaiting_audio" do
      it "selects audio where mp3 is null" do
        null_mp3 = create :audio, :enco
        live     = create :audio, :uploaded
        
        null_mp3.mp3.should be_blank
        
        Audio.awaiting_audio.should eq [null_mp3.becomes(Audio::EncoAudio)]
      end
    end
  end
  
  
  #----------------
  #----------------
  
  describe "callbacks" do
    it "receives set_file_info before create" do
      audio = create :audio, :uploaded
      audio.filename.should_not be_blank
      audio.store_dir.should_not be_blank
      Audio.any_instance.should_not_receive(:set_file_info)
      audio.save
    end
    
    it "gets set_type before create only if type is blank" do
      audio = create :audio, :direct, type: nil
      audio.type.should_not be_blank
      Audio.any_instance.should_not_receive(:set_type)
      audio.save!
    end
    
    it "receives async_compute_file_info if mp3 is present and size and duration are blank" do
      Audio.any_instance.should_receive(:async_compute_file_info).once
      create :audio, :uploaded, duration: nil, size: nil
    end
    
    it "receives async_compute_file_fields if duration is present but not size" do
      Audio.any_instance.should_receive(:async_compute_file_info)
      create :audio, :uploaded, duration: 999, size: nil
    end

    it "receives async_compute_file_fields if size is present but not duration" do
      Audio.any_instance.should_receive(:async_compute_file_info)
      create :audio, :uploaded, duration: 999, size: nil
    end
    
    it "doesn't receive async_compute_file_fields if duration and size are present" do
      Audio.any_instance.should_not_receive(:async_compute_file_info)
      create :audio, :uploaded, duration: 999, size: 8000
    end
    
    it "doesn't receive async_compute_file_fields if mp3 is not present" do
      Audio.any_instance.should_not_receive(:async_compute_file_info)
      create :audio, :enco
    end

    #----------------
    
    describe "nilify_blanks" do
      it "nilifies blanks" do
        audio = create :audio, :uploaded, description: "", byline: "", enco_number: "", mp3_path: ""
        audio.description.should eq ""
        audio.byline.should eq ""
        audio.enco_number.should eq nil
        audio.mp3_path.should eq nil
      end
    end
  end
  
  
  #----------------
  #----------------
  
  describe "#status_text" do
    it "uses the STATUS_TEXT hash to return some descriptive text" do
      audio = build :audio, :uploaded
      audio.status_text.should eq Audio::STATUS_TEXT[audio.status]
    end
  end

  #----------------
  
  describe "#status" do
    it "returns STATUS_LIVE if mp3 is present" do
      audio = build :audio, :uploaded
      audio.status.should eq Audio::STATUS_LIVE
    end
    
    it "returns STATUS_WAIT if mp3 blank but enco information present" do
      audio = build :audio, :enco
      audio.status.should eq Audio::STATUS_WAIT
    end
    
    it "returns STATUS_NONE if mp3 and enco information blank" do
      audio = build :audio
      audio.status.should eq Audio::STATUS_NONE
    end
  end
  
  #----------------
  
  describe "#live?" do
    it "is true if status is live" do
      audio = build :audio
      audio.stub(:status) { Audio::STATUS_LIVE }
      audio.live?.should be_true
    end
    
    it "is false is status is waiting" do
      audio = build :audio
      audio.stub(:status) { Audio::STATUS_WAIT }
      audio.live?.should be_false
    end
  end
  
  #----------------

  describe "#awaiting?" do
    it "is true if status is waiting" do
      audio = build :audio
      audio.stub(:status) { Audio::STATUS_WAIT }
      audio.awaiting?.should be_true
    end
    
    it "is false is status is live" do
      audio = build :audio
      audio.stub(:status) { Audio::STATUS_LIVE }
      audio.awaiting?.should be_false
    end
  end
  
  
  #----------------
  #----------------

  describe "#path" do
    it "returns the store_dir and the filename" do
      audio = create :audio, :direct
      audio.stub(:store_dir) { "somedir" }
      audio.stub(:filename)  { "something.mp3" }
      audio.path.should eq "somedir/something.mp3"
    end
  end
  
  #----------------
  
  describe "#full_path" do
    it "returns the server path to the mp3 if mp3 is present" do
      Rails.application.config.scpr.stub(:media_root) { Rails.root.join("spec/fixtures/media/some/path") }
      audio = create :audio, :uploaded
      audio.full_path.should eq Rails.root.join("spec/fixtures/media/some/path/audio/#{audio.path}").to_s
    end    
  end
  
  #----------------
  
  describe "#url" do
    it "returns the full URL to the mp3 if it's live" do
      audio = create :audio, :uploaded
      audio.url.should eq "#{Audio::AUDIO_URL_ROOT}/#{audio.path}"      
    end
    
    it "returns nil if not live" do
      audio = create :audio, :enco
      audio.url.should be_nil
    end
  end

  #----------------
  
  describe "#podcast_url" do
    it "returns the full podcast URL to the mp3 if it's live" do
      audio = create :audio, :uploaded
      audio.podcast_url.should eq "#{Audio::PODCAST_URL_ROOT}/#{audio.path}"
    end
    
    it "returns nil if mp3 not live" do
      audio = create :audio, :enco
      audio.podcast_url.should be_nil
    end
  end


  #----------------
  #----------------

  describe "#set_type" do
    it "sets to UploadedAudio if audio is live" do
      audio = create :audio, :uploaded
      audio.type.should eq "Audio::UploadedAudio"
    end
    
    it "sets to EncoAudio if enco number and date present" do
      audio = create :audio, :enco
      audio.type.should eq "Audio::EncoAudio"
    end
    
    it "sets to DirectAudio if mp3_path is present" do
      audio = create :audio, :direct
      audio.type.should eq "Audio::DirectAudio"
    end    
  end

  #----------------
  
  describe "#set_file_info" do
    it "doesn't happen if type is blank" do
      audio = build :audio, :enco
      audio.set_file_info
      audio.filename.should be_blank
    end
    
    context "for episode audio" do
      it "sends it off to ProgramAudio class methods" do
        audio = build :audio, :program, :for_episode, type: "Audio::ProgramAudio"
        Audio::ProgramAudio.should_receive(:filename).with(audio)
        Audio::ProgramAudio.should_receive(:store_dir).with(audio)

        audio.set_file_info
      end
    end
    
    context "for segment audio" do
      it "sets file info" do
        audio = build :audio, :program, :for_segment
        audio.content.show.update_attribute(:audio_dir, "coolshow")
        audio.save!
        audio.type.should eq "Audio::ProgramAudio"
        audio.store_dir.should eq "coolshow"
        audio.filename.should eq "20121002_mbrand.mp3"
      end
    end
    
    context "for uploaded audio" do
      it "sets file info" do
        time = freeze_time_at "October 21 1988"
        audio = build :audio, :uploaded
        audio.save!
        audio.type.should eq "Audio::UploadedAudio"
        audio.store_dir.should eq "upload/1988/10/21"
        audio.filename.should eq "point1sec.mp3"
      end
    end
    
    context "for enco audio" do
      it "sets file info" do
        audio = build :audio, :enco, enco_number: "99", enco_date: "October 21, 1988"
        audio.save!
        audio.type.should eq "Audio::EncoAudio"
        audio.store_dir.should eq "features"
        audio.filename.should eq "19881021_features99.mp3"
      end
    end
    
    context "for direct audio" do
      it "sets file info" do
        audio = build :audio, :direct, mp3_path: "some/cool/thing/audio.mp3"
        audio.save!
        audio.type.should eq "Audio::DirectAudio"
        audio.store_dir.should eq "some/cool/thing"
        audio.filename.should eq "audio.mp3"
      end
    end
  end
  
  
  #----------------
  #----------------

  describe "#compute_duration" do
    it "returns false if mp3 is blank" do
      audio = create :audio, :enco
      audio.compute_duration.should be_false
    end
    
    it "asks Mp3Info to open the file" do
      audio = create :audio, :uploaded
      Mp3Info.should_receive(:open).with(audio.mp3.path)
      audio.compute_duration
    end
    
    it "sets and returns the duration" do
      # Use the bigger file here because the `point1sec` file duration gets rounded down
      audio = create :audio, :uploaded, mp3: File.open(Rails.application.config.scpr.media_root.join("audio/2sec.mp3"))
      audio.compute_duration.should eq 2
      audio.duration.should eq 2
    end
    
    it "sets and returns 0 if Mp3Info can't set the duration" do
      audio = create :audio, :uploaded
      audio.duration.should be_nil
      Mp3Info.should_receive(:open)
      audio.compute_duration.should eq 0
      audio.duration.should eq 0
    end
  end

  #----------------
  
  describe "#compute_size" do
    it "returns false if mp3 is blank" do
      audio = create :audio, :enco
      audio.compute_size.should be_false
    end
    
    it "sets and returns the size" do
      audio = create :audio, :uploaded, mp3: File.open(Rails.application.config.scpr.media_root.join("audio/2sec.mp3"))
      audio.size.should be_nil
      audio.mp3.file.size.should > 0
      audio.compute_size.should eq audio.mp3.file.size
      audio.size.should eq audio.mp3.file.size
    end
  end

  #----------------
  
  describe "#compute_file_info!" do
    context "with mp3 file" do
      it "computes duration and size, and saves" do
        audio = create :audio, :uploaded
        audio.mp3.present?.should eq true
        Audio.any_instance.should_receive(:compute_duration)
        Audio.any_instance.should_receive(:compute_size)
        Audio.any_instance.should_receive(:save!)
        audio.compute_file_info!.should eq audio
      end
    end
    
    context "without mp3 file" do
      it "doesn't do anything, and returns nil" do
        audio = create :audio, :enco
        Audio.any_instance.should_not_receive(:compute_duration)
        Audio.any_instance.should_not_receive(:compute_size)
        Audio.any_instance.should_not_receive(:save!)
        audio.compute_file_info!.should eq nil
      end
    end
  end
  
  #----------------
  
  describe "#async_compute_file_info" do
    it "sends off to Resque" do
      audio = create :audio, :uploaded
      Resque.should_receive(:enqueue).with(Audio::ComputeFileInfoJob, audio.id)
      audio.async_compute_file_info
    end
  end
  
  #----------------
  
  describe "::enqueue_sync" do
    it "sends off to Resque" do
      Resque.should_receive(:enqueue).with(Audio::SyncAudioJob, "Audio")
      Audio.enqueue_sync
    end
    
    it "does it for subclasses" do
      Resque.should_receive(:enqueue).with(Audio::SyncAudioJob, "Audio::EncoAudio")
      Audio::EncoAudio.enqueue_sync
    end
  end
  
  #----------------
  
  describe "::enqueue_all" do
    it "sends to Audio::Sync::enqueue_all" do
      Audio::Sync.should_receive(:enqueue_all)
      Audio.enqueue_all
    end
  end
end
