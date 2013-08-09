FactoryGirl.define do
  factory :remote_article do
  end

  factory :chr_article, class: "RemoteArticle" do
    source "chr"
  end

  factory :npr_article, class: "RemoteArticle" do
    source "npr"
  end
end
