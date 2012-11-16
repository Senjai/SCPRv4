require "spec_helper"

describe Job::Homepage do
  it "inherits from Job::CacheTask" do
    (Job::Homepage < Job::CacheTask).should eq true
  end
end
