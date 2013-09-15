require "spec_helper"

describe Concern::Callbacks::CacheExpirationCallback do
  it "expires the object if it's already published" do
    story = create :test_class_story, :published

    set           = "obj:#{story.obj_key}"
    fragment_key  = "coolcachebro"

    $redis.set(fragment_key, "harry potter")
    $redis.sadd(set, fragment_key)

    $redis.get(fragment_key).should eq "harry potter"
    story.update_attributes(status: ContentBase::STATUS_LIVE)
    $redis.get(fragment_key).should eq nil
  end

  it "expires the object if it's unpublishing" do
    story = create :test_class_story, :published

    set           = "obj:#{story.obj_key}"
    fragment_key  = "coolcachebro"

    $redis.set(fragment_key, "harry potter")
    $redis.sadd(set, fragment_key)

    $redis.get(fragment_key).should eq "harry potter"
    story.update_attributes(status: ContentBase::STATUS_PENDING)
    $redis.get(fragment_key).should eq nil
  end

  it "expires new keys if it's publishing" do
    story = create :test_class_story, :pending

    set1            = "obj:#{TestClass::Story.new_obj_key}"
    set2            = "obj:#{ContentBase.new_obj_key}"
    fragment_key1   = "bagel"
    fragment_key2   = "burrito"

    $redis.set(fragment_key1, "delicious")
    $redis.set(fragment_key2, "extra-delicious")

    $redis.sadd(set1, fragment_key1)
    $redis.sadd(set2, fragment_key2)

    $redis.get(fragment_key1).should eq "delicious"
    $redis.get(fragment_key2).should eq "extra-delicious"
    story.update_attributes(status: ContentBase::STATUS_LIVE)
    $redis.get(fragment_key1).should eq nil
    $redis.get(fragment_key2).should eq nil
  end
end
