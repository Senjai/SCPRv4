require "spec_helper"

describe MissedItBucket do
  describe 'slug generation' do
    subject { create :missed_it_bucket, title: "What What", slug: nil }

    its(:slug) { should eq "what-what" }
  end
end
