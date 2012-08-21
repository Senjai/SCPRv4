require 'spec_helper'

describe SectionPromotion do
  describe "associations" do
    it { should belong_to(:section) }
    it { should belong_to(:promotion) }
  end
end
