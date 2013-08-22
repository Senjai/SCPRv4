require 'spec_helper'

describe Concern::Associations::EditionsAssociation do
  it 'updates the editions when the object is saved' do
    edition       = create :edition
    post          = create :test_class_post
    edition_slot  = create :edition_slot, item: post, edition: edition

    # reload the post so it can become aware of its new edition slot
    post.reload

    # set the updated_at timestamp to long ago so we don't have to use `sleep`
    edition.update_column(:updated_at, Time.now.yesterday)

    post.update_attributes(headline: "Updated Headline!?")

    # Don't really care what the exact updated at timestamp is...
    # we just want to make sure it changed to "right now"
    # If we use `Time.now`, it would fail occassionally.
    edition.reload.updated_at.should be > 1.minute.ago
  end
end
