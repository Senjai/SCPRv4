FactoryGirl.define do
  factory :external_program do
    sequence(:title) { |n| "External Program #{n}" }
    slug        { title.parameterize }
    air_status  "onair"

    # Provide default for the dumb shared specs
    from_rss

    trait :from_rss do
      podcast_url "http://www.kqed.org/rss/private/californiareport.xml"
      source  "rss"
    end

    trait :from_npr do
      source "npr-api"
      external_id 999
    end
  end


  factory :external_episode do
    external_program
    sequence(:air_date) { |n| Time.now + n.hours }
    title { "#{external_program.title} for #{air_date}" }
  end


  factory :external_segment do
    sequence(:title) { |n| "Some Segment #{n}"}
    sequence(:published_at) { |n| Time.now + n.hours }
    external_program

    trait :from_npr do
      external_id "999"
      source "npr-api"
    end

    trait :from_rss do
      external_id "http://www.npr.org/2013/07/16/202367740/laughs-and-drama-behind-bars-with-orange-is-the-new-black?ft=1&f=13"
      source "rss"
    end
  end


  factory :external_episode_segment do
    external_episode
    external_segment
  end
end
