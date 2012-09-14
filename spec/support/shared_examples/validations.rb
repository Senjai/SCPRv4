require "spec_helper"

def symbolize(klass)
  klass.to_s.underscore.to_sym
end

# SlugValidation
shared_examples_for "slug validation" do
  it { should validate_presence_of(:slug) }
  it { should validate_format_of(:slug).with(Model::Validations::DEFAULTS[:slug_format]) }
end

shared_examples_for "slug unique validation" do
  it "validates uniqueness of slug" do
    create symbolize(described_class)
    should validate_uniqueness_of :slug
  end
end

shared_examples_for "content validation" do
  
end

shared_examples_for "slug unique for date validation" do
  it "validates slug uniqueness for date" do
    stub_publishing_callbacks(described_class)
    
    object1 = create symbolize(described_class), slug: "something", scope => Chronic.parse("Wednesday 8pm")
    object2 = build  symbolize(described_class), slug: "something", scope => Chronic.parse("Tuesday 8pm")
    object3 = build  symbolize(described_class), slug: "something", scope => object1.send(scope)

    object2.should be_valid
    object3.should_not be_valid
    object3.errors.keys.should include :slug
  end
end
