require 'spec_helper'

describe Concern::Associations::FeaturedCommentAssociation do
  before :each do
    @post = create :test_class_post, :published
    @comment = create :featured_comment, content: @post
    @comment.content(true).should eq @post
  end

  it "destroys the join record on destroy" do
    @post.destroy
    @comment.content(true).should eq nil
  end

  it "destroys the join record on unpublish" do
    @post.status = ContentBase::STATUS_PENDING
    @post.save!

    @comment.content(true).should eq nil
    @post.featured_comments(true).should eq []
  end

  it "doesn't destroy the join records on normal save" do
    @post.headline = "Updated"
    @post.save!

    @comment.content(true).should eq @post
    @post.featured_comments(true).should eq [@comment]
  end
end
