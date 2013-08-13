require 'spec_helper'

describe AudioVision::Post do
  describe '::find_by_url' do
    it "finds the post" do
      stub_request(:get, %r|api/v1/posts|).to_return({
        :content_type => "application/json",
        :body => load_fixture("api/audiovision/post_v1.json")
      })

      post = AudioVision::Post.find_by_url("http://audiovision.scpr.org/posts/104")
      post.should be_a AudioVision::Post
      post.id.should eq "posts:104"
    end

    it "returns nil if no post is found" do
      stub_request(:get, %r|api/v1/posts|).to_return({
        :content_type   => "application/json",
        :body           => { error: "Not Found" },
        :status         => 404
      })

      post = AudioVision::Post.find_by_url("http://audiovision.scpr.org/posts/104")
      post.should eq nil
    end
  end

  describe "new" do
    it 'is a Post' do
      post = AudioVision::Post.new({"id" => "posts:104", "published_at" => Time.now.to_s})
      post.id.should eq "posts:104"
      post.assets.should eq Array.new
    end
  end
end
