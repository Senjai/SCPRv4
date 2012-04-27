require "spec_helper"

describe "custom routes" do
  describe "blog_path" do
    it "uses the slug for the path" do
      blog = create :blog
      blog_path(blog).should eq "/blogs/#{blog.slug}/"
    end
  end
  
  describe "video_path" do
    it "has the video's slug in the path" do
      video = create :video_shell
      video_path(video).should eq "/video/#{video.id}/#{video.slug}/"
    end
  end
end