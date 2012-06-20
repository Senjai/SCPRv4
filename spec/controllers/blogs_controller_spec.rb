require "spec_helper"

describe BlogsController do
  describe "GET /entry" do
    it "assigns @entry" do
      blog = create :blog
      entry_published = create :blog_entry, blog: blog, status: 5
      p = entry_published.published_at
      get :entry, blog: blog.slug, year: p.year, month: "%02d" % p.month, day: "%02d" % p.day, id: entry_published.id, slug: entry_published.slug
      assigns(:entry).should eq entry_published
    end
    
    it "raises a routing error if entry isn't found" do
      blog = create :blog
      entry_unpublished = create :blog_entry, blog: blog, status: 4
      p = entry_unpublished.published_at
      lambda {
        get :entry, blog: blog.slug, year: p.year, month: "%02d" % p.month, day: "%02d" % p.day, id: entry_unpublished.id, slug: entry_unpublished.slug
      }.should raise_error ActionController::RoutingError
    end
  end
end