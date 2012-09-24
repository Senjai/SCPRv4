require "spec_helper"

describe Audio do
  describe "associations" do
    it { should belong_to(:content) }
  end
  
  #----------------
  
  describe "scopes" do
    describe "available" do
      it "selects only audio objects with mp3 present" do
        available   = create :audio, :live
        unavailable = create :audio, :with_enco # mp3 is blank
        
        Audio.available.should eq [available]
      end
      
      it "Treats null and blank mp3 the same" do
        available = create :audio, :live
        blank     = create :audio, :with_enco, mp3: nil
        empty     = create :audio, :with_enco, mp3: ""
        
        blank.mp3.should eq nil
        empty.mp3.should eq ""
        
        Audio.available.should eq [available]
      end
    end

    #----------------
    
    describe "with_enco" do
      it "selects any audio with enco information" do
        no_enco = create :audio, :live
        enco    = create :audio, :with_enco
        Audio.with_enco.should eq [enco]
      end
      
      it "treats null and 0 the same for enco number" do
        enco      = create :audio, :with_enco
        null_enco = create :audio, enco_number: nil,  enco_date: Date.today
        zero_enco = create :audio, enco_number: 0,    enco_date: Date.today
                
        null_enco.enco_number.should eq nil
        zero_enco.enco_number.should eq 0
        
        Audio.with_enco.should eq [enco]
      end
      
      it "doesn't select audio with null enco_date" do
        enco    = create :audio, :with_enco
        no_date = create :audio, enco_number: 999, enco_date: nil
        
        no_date.enco_date.should eq nil
        
        Audio.with_enco.should eq [enco]
      end
    end

    #----------------
    
    describe "awaiting_enco" do
      it "selects audio where mp3 is null" do
        null_mp3 = create :audio, :with_enco
        live     = create :audio, :live
        
        null_mp3.mp3.should eq nil
        
        Audio.awaiting_enco.should eq [null_mp3]
      end
      
      it "selects audio with blank mp3" do
        blank_mp3 = create :audio, :with_enco, mp3: ""
        live     = create :audio, :live
        
        blank_mp3.mp3.should eq ""
        
        Audio.awaiting_enco.should eq [blank_mp3]
      end
    end
  end

  #----------------

  describe "path_elements" do
    it "splits the stored path into an array by a delimiter" do
      audio = build :audio, :live, mp3: "audio/something/cool_story_bro.mp3"
      audio.path_elements.should eq ["audio", "something", "cool_story_bro.mp3"]
    end
  end
  
  #----------------
  
  describe "url" do
    it "returns the full URL to the mp3 if it's available" do
      audio = build :audio, :live
      audio.url.should eq "#{Audio::AUDIO_ROOT}/#{audio.mp3}"      
    end
    
    it "returns nil if mp3 is blank" do
      audio = build :audio, :with_enco
      audio.url.should be_nil
    end
  end

  #----------------
  
  describe "podcast_url" do
    it "returns the full podcast URL to the mp3 if it's available" do
      audio = build :audio, :live
      audio.podcast_url.should eq "#{Audio::PODCAST_ROOT}/#{audio.mp3.gsub(/audio\//, "")}"
    end
    
    it "does not match the audio/ path" do
      audio = build :audio, :live, mp3: "audio/slug/cool-story-bro.mp3"
      audio.podcast_url.should_not match "audio/"
    end
    
    it "returns nil if mp3 is blank" do
      audio = build :audio, :with_enco
      audio.podcast_url.should be_nil
    end
  end

  #----------------
  
  describe "mp3_path" do
    it "returns the server path to the mp3 if mp3 is present" do
      Rails.application.config.scpr.stub(:media_root) { "/some/path" }
      audio = build :audio, :live
      audio.mp3_path.should eq "/some/path/#{audio.mp3}"
    end
    
    it "returns nil if mp3 is not present" do
      audio = build :audio, :with_enco
      audio.mp3_path.should eq nil
    end
  end

  #----------------
  
  describe "status_text" do
    it "uses the STATUS_TEXT hash to return some descriptive text" do
      audio = build :audio, :live
      audio.status_text.should eq Audio::STATUS_TEXT[audio.status]
    end
  end

  #----------------
  
  describe "status" do
    it "returns STATUS_LIVE if mp3 is present" do
      audio = build :audio, :live
      audio.status.should eq Audio::STATUS_LIVE
    end
    
    it "returns STATUS_WAIT if mp3 blank but enco information present" do
      audio = build :audio, :with_enco
      audio.status.should eq Audio::STATUS_WAIT
    end
    
    it "returns STATUS_NONE if mp3 and enco information blank" do
      audio = build :audio
      audio.status.should eq Audio::STATUS_NONE
    end
  end
end
