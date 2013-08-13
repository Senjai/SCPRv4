##
# Breaking News Alerts
#
FactoryGirl.define do
  factory :breaking_news_alert do
    headline      "Breaking news!"
    teaser        "This is breaking news"
    alert_type    "break"
    alert_url    "http://scpr.org/"
    visible       true
    status BreakingNewsAlert::STATUS_PUBLISHED

    send_email    false
    email_sent    false

    send_mobile_notification false
    mobile_notification_sent false

    trait :published do
      status BreakingNewsAlert::STATUS_PUBLISHED
      sequence(:published_at) { |n| Time.now + n.minutes }
    end

    trait :pending do
      status BreakingNewsAlert::STATUS_PENDING
    end

    trait :email do
      send_email true
    end

    trait :mobile do
      send_mobile_notification true
    end
  end
end
