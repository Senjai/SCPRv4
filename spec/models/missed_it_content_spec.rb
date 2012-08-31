require "spec_helper"

describe MissedItContent do
  it { should belong_to :missed_it_bucket }
  it { should belong_to :content }
end
