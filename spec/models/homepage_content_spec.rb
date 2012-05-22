require "spec_helper"

describe HomepageContent do
  it { should belong_to(:homepage) }
  it { should belong_to(:content) }
end