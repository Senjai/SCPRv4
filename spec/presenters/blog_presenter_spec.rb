require "spec_helper"

describe BlogPresenter do
  describe "#rss_link" do
    it "returns blog.rss_url if specified" do
      blog = build :blog
      blog.related_links.build(title: "RSS", url: "show.com/airtalk", link_type: "rss")
      p = presenter(blog)
      p.rss_link.should match %r{show\.com/airtalk}
    end

    it "returns nil if not specified" do
      blog = build :blog
      p = presenter(blog)
      p.rss_link.should eq nil
    end
  end


  describe "#facebook_link" do
    it "returns the facebook link if specified" do
      blog = build :blog
      blog.related_links.build(title: "Facebook", url: "facebook.com/airtalk", link_type: "facebook")
      p = presenter(blog)
      p.facebook_link.should match %r{facebook\.com/airtalk}
    end

    it "returns nil if not specified" do
      blog = build :blog
      p = presenter(blog)
      p.facebook_link.should eq nil
    end
  end

  describe "#twitter_link" do
    it "returns the twitter url if twitter handle is presen t" do
      blog = build :blog, twitter_handle: "airtalk"
      p = presenter(blog)
      p.twitter_link.should match %r{twitter\.com/airtalk}
    end

    it "returns nil if not specified" do
      blog = build :blog, twitter_handle: ""
      p = presenter(blog)
      p.twitter_link.should eq nil
    end
  end
end
