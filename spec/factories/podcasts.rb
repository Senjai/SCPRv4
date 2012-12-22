##
# Podcasts
#
FactoryGirl.define do
  factory :podcast do
    sequence(:title) { |n| "Podcast #{n}" }
    slug { title.parameterize }
    author "KPCC 89.3 | Southern California Public Radio"
    source { |p| p.association :kpcc_program }
    item_type 'episodes'
    podcast_url { "http://www.scpr.org/podcasts/loh_down" }
    image_url { "http://media.scpr.org/assets/images/podcasts/#{slug}.png" }
    keywords "KPCC, Los Angeles, Southern California, LA"
    url { "http://www.scpr.org/programs/#{slug}" }
    duration 0
  end
end
