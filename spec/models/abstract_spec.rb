require 'spec_helper'

describe Abstract do
  describe '#to_abstract' do
    it 'is itself' do
      abstract = create :abstract
      abstract.to_abstract.should eq abstract #abstract
    end
  end
end
