##
# Users
#
FactoryGirl.define do
  factory :bio, class: "Bio", aliases: [:author] do
    user { |bio| bio.association :admin_user }
    sequence(:name) { |n| "Bryan Ricker #{n}" }

    is_public true
    slug { name.parameterize }
    twitter_handle { slug }

    bio          "This is a bio"
    short_bio    "Short!"
    title        "Rails Developer"
    phone_number "123-456-7890"
  end

  #---------------------------
  
  factory :admin_user, aliases: [:user] do
    name "Bryan Ricker"
    old_password '$2a$10$HSJMxubR06Ap.xKmxiPpf.Kbbl/lgHadoVB.wynnEfte7b4BY4bDy'
    password "secret"
    last_login { Time.now }
    sequence(:email) { |i| "user#{i}@scpr.org" }

    can_login 1
    is_superuser 1
  end
end
