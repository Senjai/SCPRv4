FactoryGirl.define do
  factory :external_program do
    sequence(:title) { |n| "Other Program #{n}" }
    slug        { title.parameterize }
    air_status  "onair"
    podcast_url "http://www.npr.org/rss/podcast.php?id=510005"
    rss_url     "http://www.kqed.org/rss/private/californiareport.xml"
  end

  factory :external_episode do
  end

  factory :external_segment do
  end
end
