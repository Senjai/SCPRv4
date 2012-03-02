require 'spec_helper'

describe NewsStory do
  it ".published correctly limits published stories" do
    s_count = NewsStory.where(:status => ContentBase::STATUS_LIVE).count()
    NewsStory.published.count.should == s_count
  end
end