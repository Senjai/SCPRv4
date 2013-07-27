##
# Audio
#
FactoryGirl.define do
  factory :audio do
    trait :uploaded do
      content { |a| a.association :news_story }
      mp3 File.open(Rails.application.config.scpr.media_root.join("audio/point1sec.mp3"))
    end

    trait :enco do
      content { |a| a.association :news_story }
      enco_number 1488
      enco_date { Date.today }
    end

    trait :direct do
      content { |a| a.association :news_story }
      external_url "http://media.scpr.org/audio/events/2012/10/02/SomeCoolEvent.mp3"
    end

    trait :program do
      type "Audio::ProgramAudio" # Typecast this object since Audio#set_type doesn't do it for ProgramAudio
      mp3 File.open(Rails.application.config.scpr.media_root.join("audio/mbrand/20121002_mbrand.mp3"))
    end

    trait :for_episode do
      content { |a| a.association :show_episode }
    end

    trait :for_segment do
      content { |a| a.association :show_segment }
    end

    #---------

    factory :program_audio, class: "Audio::ProgramAudio" do
      for_episode
      program
    end

    factory :enco_audio, class: "Audio::EncoAudio" do
      enco
    end

    factory :direct_audio, class: "Audio::DirectAudio" do
      direct
    end

    factory :uploaded_audio, class: "Audio::UploadedAudio" do
      uploaded
    end
  end
end
