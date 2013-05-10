require 'spec_helper'

describe Job::AudioVisionCache do
  describe '::perform' do
    it 'caches the first post if the billboard has not been cached yet' do
      FakeWeb.register_uri(:get, %r{audiovision\.scpr\.org/api/v1/billboards/current},
        content_type: 'application/json', body: load_fixture('audiovision/billboard1_v1.json'))

      Job::AudioVisionCache.perform
      Rails.cache.read("scprv4:homepage:av-featured-post").should eq AudioVision::Billboard.current.posts.first
    end


    it "caches the first post if the billboard's updated_timestamp has changed" do
      # Sanity Check
      FakeWeb.register_uri(:get, %r{audiovision\.scpr\.org/api/v1/billboards/current},
        content_type: 'application/json', body: load_fixture('audiovision/billboard1_v1.json'))

      Job::AudioVisionCache.perform
      Rails.cache.read("scprv4:homepage:av-featured-post").title.should match /Big Cats/

      # Now test that it will change
      FakeWeb.register_uri(:get, %r{audiovision\.scpr\.org/api/v1/billboards/current},
        content_type: 'application/json', body: load_fixture('audiovision/billboard1_updated_v1.json'))

      Job::AudioVisionCache.perform
      Rails.cache.read("scprv4:homepage:av-featured-post").title.should match /Color of Space/
    end


    it "caches a different post if the updated timestamp has not changed" do
      FakeWeb.register_uri(:get, %r{audiovision\.scpr\.org/api/v1/billboards/current},
        content_type: 'application/json', body: load_fixture('audiovision/billboard1_v1.json'))

      Job::AudioVisionCache.perform
      # Sanity Check
      featured = Rails.cache.read("scprv4:homepage:av-featured-post")
      featured.title.should match /Big Cats/ # First post

      last_title = featured.title

      # Test that it will change.
      # Do it 10 times so we can be reasonably sure
      # that it never chooses the same post twice in 
      # a row.
      10.times do
        Job::AudioVisionCache.perform
        featured = Rails.cache.read("scprv4:homepage:av-featured-post")
        featured.title.should_not eq last_title
        last_title = featured.title
      end
    end
  end
end
