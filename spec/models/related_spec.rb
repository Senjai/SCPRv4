require "spec_helper"

describe Related do
  it { should belong_to(:related) }
  it { should belong_to(:content) }  
end
