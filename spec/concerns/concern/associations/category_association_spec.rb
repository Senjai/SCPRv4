require "spec_helper"

describe Concern::Associations::CategoryAssociation do
  subject { TestClass::Story.new }
  
  it { should belong_to(:category) }
end
