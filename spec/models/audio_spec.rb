require "spec_helper"

describe Audio do
  describe 'enco information validation' do
    context "#enco_info_is_present_together" do
      it "fails if enco_number present but not enco_date" do
        audio = build :audio, enco_date: nil, enco_number: 999
        audio.should_not be_valid
        audio.errors.keys.should eq [:base, :enco_number, :enco_date]
      end

      it "fails if enco_date present but not enco_number" do
        audio = build :audio, enco_date: Date.today, enco_number: nil
        audio.should_not be_valid
        audio.errors.keys.should eq [:base, :enco_number, :enco_date]
      end

      it "passes if enco_date and enco_number are present" do
        audio = build :audio, enco_date: Date.today, enco_number: 999
        audio.should be_valid
      end

      it "passes if neither enco_date nor enco_number were provided" do
        audio = build :audio, :direct, enco_date: nil, enco_number: nil
        audio.should be_valid
      end
    end
  end


  describe "validations" do
    context "#audio_source_is_provided" do
      it "is valid if only enco_number and enco_date present" do
        audio = build :audio, :enco, external_url: nil, mp3: nil
        audio.should be_valid
      end

      it "is valid if only external_url present" do
        audio = build :audio, :direct, enco_number: nil, enco_date: nil, mp3: nil
        audio.should be_valid
      end

      it "is valid if only mp3 present" do
        audio = build :audio, :uploaded, external_url: nil, enco_number: nil, enco_date: nil
        audio.should be_valid

        purge_uploaded_audio
      end

      it "is invalid if everything is blank" do
        audio = build :audio, mp3: nil, external_url: nil, enco_number: nil, enco_date: nil
        audio.should_not be_valid
        audio.errors.keys.should eq [:base]
      end
    end

    #----------------

    context '#path_is_unique' do
      after :each do
        purge_uploaded_audio
      end

      it 'validates that the filename is unique' do
        existing_audio = create :audio, :uploaded
        new_audio      = build :audio, :uploaded

        new_audio.valid?.should eq false
        new_audio.errors.keys.should eq [:mp3]
        new_audio.errors[:mp3].first.should match /already exists/
      end

      it 'only runs on new records' do
        Audio.any_instance.should_receive(:path_is_unique).once
        audio = create :audio, :uploaded
        audio.save!
      end

      it 'only runs on UploadedAudio' do
        Audio.any_instance.should_not_receive(:path_is_unique)
        audio = create :direct_audio
      end
    end
  end


  #----------------
  #----------------

  describe "scopes" do
    describe "::available" do
      after :each do
        purge_uploaded_audio
      end

      it "selects only live status" do
        available   = create :uploaded_audio, :uploaded
        unavailable = create :audio, :enco # mp3 is blank
        Audio.available.should eq [available]
      end
    end

    #----------------

    describe "::awaiting_audio" do
      after :each do
        purge_uploaded_audio
      end

      it "selects audio where mp3 is null" do
        null_mp3 = create :enco_audio
        live     = create :audio, :uploaded

        null_mp3.mp3.should be_blank

        Audio.awaiting_audio.should eq [null_mp3]
      end
    end
  end


  #----------------
  #----------------

  describe "callbacks" do
    after :each do
      purge_uploaded_audio
    end

    it "gets set_type before create only if type is blank" do
      audio = create :audio, :direct, type: nil
      audio.type.should_not be_blank
      Audio.any_instance.should_not_receive(:set_type)
      audio.save!
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


    describe 'setting the status' do
      it "sets STATUS_LIVE for uploaded audio" do
        audio = create :audio, :uploaded
        audio.status.should eq Audio::STATUS_LIVE
        purge_uploaded_audio
      end

      it "sets STATUS_LIVE for program audio" do
        audio = create :audio, :program, :for_episode
        audio.status.should eq Audio::STATUS_LIVE
        audio.mp3.remove!
      end

      it "sets STATUS_LIVE for direct audio" do
        audio = create :audio, :direct
        audio.status.should eq Audio::STATUS_LIVE
      end

      it "sets STATUS_WAIT for enco audio" do
        audio = create :audio, :enco
        audio.status.should eq Audio::STATUS_WAIT
      end
    end
  end

  describe '#path' do
    it 'gets generated before save' do
      audio = build :audio, :enco
      audio.path.should eq nil
      audio.save!

      audio.path.should eq File.join(audio.store_dir, audio.filename)
    end

    it 'does it for typecasted things too... great description bro' do
      audio = build :enco_audio
      audio.path.should eq nil
      audio.save!

      audio.path.should eq File.join(audio.store_dir, audio.filename)
    end
  end

  describe "#status_text" do
    it "uses the STATUS_TEXT hash to return some descriptive text" do
      audio = build :audio, :enco
      audio.status_text.should eq Audio::STATUS_TEXT[audio.status]
    end
  end

  #----------------

  describe "#live?" do
    it "is true if status is live" do
      audio = build :audio, status: Audio::STATUS_LIVE
      audio.live?.should eq true
    end

    it "is false is status is waiting" do
      audio = build :audio, status: Audio::STATUS_WAIT
      audio.live?.should eq false
    end
  end


  #----------------
  #----------------

  describe "setting the type" do
    after :each do
      purge_uploaded_audio
    end

    it "sets to UploadedAudio if audio is live" do
      audio = create :audio, :uploaded
      audio.type.should eq "Audio::UploadedAudio"
    end

    it "sets to EncoAudio if enco number and date present" do
      audio = create :audio, :enco
      audio.type.should eq "Audio::EncoAudio"
    end

    it "sets to DirectAudio if external_url is present" do
      audio = create :audio, :direct
      audio.type.should eq "Audio::DirectAudio"
    end
  end

  #----------------

  describe "#async_compute_file_info" do
    after :each do
      purge_uploaded_audio
    end

    it "sends off to Resque" do
      audio = create :audio, :uploaded
      Resque.should_receive(:enqueue).with(Job::ComputeAudioFileInfo, audio.id)
      audio.async_compute_file_info
    end
  end

  #----------------

  describe "::enqueue_sync" do
    it "sends off to Resque" do
      Resque.should_receive(:enqueue).with(Job::SyncAudio, "Audio")
      Audio.enqueue_sync
    end

    it "does it for subclasses" do
      Resque.should_receive(:enqueue).with(Job::SyncAudio, "Audio::EncoAudio")
      Audio::EncoAudio.enqueue_sync
    end
  end

  #----------------

  describe "::enqueue_all" do
    it "enqueues the stuff" do
      Resque.should_receive(:enqueue).twice
      Audio.enqueue_all
    end
  end
end
