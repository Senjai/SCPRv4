require 'spec_helper'

describe Concern::Associations::HomepageContentAssociation do
  before :each do
    @post = create :test_class_post, :published
    @homepage = create :homepage
    @homepage_content = create :homepage_content, content: @post, homepage: @homepage
    @homepage.content(true).should eq [@homepage_content]
  end

  it "destroys the join record on destroy" do
    @post.destroy
    @homepage.content(true).should eq []
  end

  it "destroys the join record on unpublish" do
    @post.status = ContentBase::STATUS_PENDING
    @post.save!

    @homepage.content(true).should eq []
    @post.homepage_contents(true).should eq []
  end

  it "doesn't destroy the join records on normal save" do
    @post.headline = "Updated"
    @post.save!

    @homepage.content(true).should eq [@homepage_content]
    @post.homepage_contents(true).should eq [@homepage_content]
  end
end
