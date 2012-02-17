FactoryGirl.define do
  factory :video_shell do
    headline "This is a video"
    status 5
    published_at Time.now
    
    body "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque a enim a leo auctor lobortis. Etiam aliquam metus sit amet nulla blandit molestie. Cras lobortis odio non turpis laoreet non congue libero commodo. Vestibulum dolor nibh, eleifend eu suscipit eget, egestas sed diam. Proin cursus rutrum nibh eget consequat. Donec viverra augue sed nisl ultrices venenatis id eget quam. Cras id dui a magna tristique fermentum in sit amet lacus. Curabitur urna metus, mattis vel mollis quis, placerat vitae turpis.

    Phasellus et tortor eget mauris imperdiet fermentum. Mauris a rutrum augue. Quisque at fringilla libero. Phasellus vitae nisl turpis, at sodales erat. Duis et risus orci, at placerat quam. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Etiam sed nibh non odio pretium rhoncus et nec ipsum. Nam sed dignissim velit."
  end
  
  factory :news_story do
    primary_reporter
    seconday_reporter
    headline "This is a news story"
    slug "news-story"
    news_agency "KPCC"
    _teaser "This is a teaser"
    body "This is a big block of text for the news story"
    locale "local"
    published_at Time.now
    editing_status 2
    is_published 1
    status 5
  end
    
end