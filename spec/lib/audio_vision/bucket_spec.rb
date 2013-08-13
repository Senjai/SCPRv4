require 'spec_helper'

describe AudioVision::Bucket do
  describe '::find_by_key' do
    it 'finds the bucket if available' do
      stub_request(:get, %r|api/v1/buckets|).to_return({
        :content_type => "application/json",
        :body => load_fixture("api/audiovision/bucket_v1.json")
      })

      bucket = AudioVision::Bucket.find_by_key('featured-posts')
      bucket.should be_a AudioVision::Bucket
      bucket.id.should eq "featured-posts"
    end

    it "is nil if nothing found" do
      stub_request(:get, %r|api/v1/buckets|).to_return({
        :content_type   => "application/json",
        :body           => { error: "Not Found" },
        :status         => 404
      })

      bucket = AudioVision::Bucket.find_by_key('lolnope')
      bucket.should eq nil
    end
  end

  describe 'new' do
    it 'makes a new Bucket object' do
      bucket = AudioVision::Bucket.new({"id" => "featured-posts", "updated_at" => Time.now.to_s})
      bucket.id.should eq "featured-posts"
      bucket.posts.should eq Array.new
    end
  end
end
