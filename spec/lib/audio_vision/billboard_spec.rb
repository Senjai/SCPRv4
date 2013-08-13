require 'spec_helper'

describe AudioVision::Billboard do
  describe '::current' do
    it 'finds the current billboard' do
      stub_request(:get, %r|api/v1/billboards/current|).to_return({
        :content_type => "application/json",
        :body => load_fixture("api/audiovision/billboard1_v1.json")
      })

      billboard = AudioVision::Billboard.current
      billboard.should be_a AudioVision::Billboard
      billboard.id.should eq "billboards:1"
    end

    it "is nil if nothing found" do
      stub_request(:get, %r|api/v1/billboards/current|).to_return({
        :content_type   => "application/json",
        :body           => { error: "Not Found" },
        :status         => 404
      })

      billboard = AudioVision::Billboard.current
      billboard.should eq nil
    end
  end

  describe 'new' do
    it 'makes a new Billboard object' do
      t = Time.now

      billboard = AudioVision::Billboard.new({"id" => "billboards:1", "published_at" => t.to_s})
      billboard.id.should eq "billboards:1"
      billboard.published_at.to_s.should eq t.to_s
      billboard.posts.should eq Array.new
    end
  end
end
