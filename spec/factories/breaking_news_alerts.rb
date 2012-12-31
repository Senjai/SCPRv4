##
# Breaking News Alerts
#
FactoryGirl.define do
  factory :breaking_news_alert do
    headline      "Breaking news!"
    teaser        "This is breaking news"
    alert_time    { Time.now }
    alert_type    "break"
    alert_link    "http://scpr.org/"
    is_published  1
    visible       1
    email_sent    0
    send_email    0
  end
end
