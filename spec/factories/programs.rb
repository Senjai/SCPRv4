##
# Programs
#
FactoryGirl.define do
  factory :kpcc_program, aliases: [:show] do
    sequence(:title) { |n| "Show #{n}" }
    slug { title.parameterize }    
    air_status "onair"

    trait :episodic do
      display_episodes 1
    end

    trait :segmented do
      display_segments 1
    end
  end

  #--------------------
  
  factory :other_program do
    sequence(:title) { |n| "Other Program #{n}" }
    slug        { title.parameterize }
    air_status  "onair"
    podcast_url "http://www.npr.org/rss/podcast.php?id=510005"
    rss_url     "http://www.kqed.org/rss/private/californiareport.xml"
  end
end
