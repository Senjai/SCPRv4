FactoryGirl.define do
  factory :show_segment do
    sequence(:headline) { |n| "Some Content #{n}" }
    sequence(:short_headline) { |n| "Short #{n}" }

    body    { "Body for #{headline}" }
    teaser  { "Teaser for #{headline}" }

    slug { headline.parameterize }
    show
    published
  end

  factory :show_episode do
    sequence(:headline) { |n| "Some Content #{n}" }
    body    { "Body for #{headline}" }

    sequence(:air_date) { |n| (Time.now + 60*60*24*n).strftime("%Y-%m-%d") }

    show { |r| r.association(:kpcc_program) }
    published
  end

  factory :show_rundown do
    episode { |r| r.association(:show_episode) }
    segment { |r| r.association(:show_segment) }
  end
end
