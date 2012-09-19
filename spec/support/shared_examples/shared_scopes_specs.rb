## Shared Scopes
# Model::Scopes
#

def symbolize(klass)
  klass.to_s.underscore.to_sym
end

#-----------------
# SinceScope
shared_examples_for "since scope" do
  it "gets only the records from the specified limit" do
    recent     = create symbolize(described_class), published_at: 1.day.ago
    really_old = create symbolize(described_class), published_at: 1.year.ago

    described_class.since(1.hour.ago).should eq []
    described_class.since(3.days.ago).should eq [recent]
    described_class.since(2.years.ago).sort.should eq [recent, really_old].sort
  end
end
