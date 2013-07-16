FactoryGirl.define do
  factory :external_program do
    sequence(:title) { |n| "External Program #{n}" }
    slug        { title.parameterize }
    air_status  "onair"

    trait :from_rss do
      rss_url "http://www.kqed.org/rss/private/californiareport.xml"
      source  "rss"
      is_episodic false
    end

    trait :from_npr do
      source "npr-api"
      external_id 999
      is_episodic true
    end
  end


  factory :external_episode do
    external_program
    sequence(:air_date) { |n| Time.now + n.hours }
    title { "#{external_program.title} for #{airdate}" }
  end


  factory :external_segment do
    sequence(:title) { |n| "Some Segment #{n}"}
    sequence(:published_at) { |n| Time.now + n.hours }

    trait :from_npr do
      external_id "999"
      source "npr-api"
    end

    trait :from_rss do
      external_program
      external_id "http://www.npr.org/2013/07/16/202367740/laughs-and-drama-behind-bars-with-orange-is-the-new-black?ft=1&f=13"
      source "rss"
    end
  end


  factory :external_episode_segment do
    external_episode
    external_segment
  end
end
