##
# Programs
#
FactoryGirl.define do
  factory :kpcc_program, aliases: [:show] do
    sequence(:title) { |n| "Show #{n}" }
    slug { title.parameterize }
    air_status "onair"

    audio_dir "airtalk" # lazy

    trait :episodic do
      display_episodes 1
    end

    trait :segmented do
      display_segments 1
    end
  end
end
