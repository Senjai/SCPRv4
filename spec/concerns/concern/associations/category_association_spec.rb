require "spec_helper"

describe Concern::Associations::CategoryAssociation do
  subject { TestClass::Story.new }
  
  it { should have_one(:content_category) }
  it { should have_one(:category).through(:content_category) }
end
