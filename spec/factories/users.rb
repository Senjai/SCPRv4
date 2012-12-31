##
# Users
#
FactoryGirl.define do
  factory :bio, class: "Bio", aliases: [:author] do
    user { |bio| bio.association :admin_user }
    sequence(:name) { |n| "Bryan Ricker #{n}" }

    is_public    true
    slug         { name.parameterize }
    twitter      { "@#{slug}" }

    bio          "This is a bio"
    short_bio    "Short!"
    title        "Rails Developer"
    phone_number "123-456-7890"
  end

  #---------------------------
  
  factory :admin_user do
    # To be removed:
    sequence(:first_name) { |n| "Bryan #{n}" }
    last_name   "Ricker"
    password    "sha1$vxA3aP5quIgd$aa7c53395bf8d6126c02ec8ef4e8a9b784c9a2f7" # `secret`, salted & digested
    date_joined { Time.now }
    #

    unencrypted_password "secret"
    unencrypted_password_confirmation { unencrypted_password }
    last_login { Time.now }
    sequence(:email) { |i| "user#{i}@scpr.org" }

    is_staff 1
    is_active 1
    is_superuser 1

    trait :staff_user do
      is_staff     1
      is_active    1
      is_superuser 0
    end

    trait :superuser do
      is_staff     1
      is_active    1
      is_superuser 1
    end
  end
end
