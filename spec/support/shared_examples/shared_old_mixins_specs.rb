def symbolize(klass)
  klass.to_s.underscore.to_sym
end

#---------------------------
# Basic unique slug validation
shared_examples_for "slug unique validation" do
  context "should validate" do
    before :each do
      described_class.any_instance.stub(:should_validate?) { true }
    end

    it "validates uniqueness of slug" do
      create symbolize(described_class)
      should validate_uniqueness_of :slug
    end
  end
  
  context "should validate" do
    before :each do
      described_class.any_instance.stub(:should_validate?) { false }
    end

    it "validates uniqueness of slug" do
      create symbolize(described_class)
      should validate_uniqueness_of :slug
    end
  end
end


# Just keeping these so I can search for them later
# Should be deleted eventually
shared_examples_for "slug validation" do end
shared_examples_for "content validation" do end
shared_examples_for "slug unique for date validation" do end
shared_examples_for "published at validation" do end

shared_examples_for "content alarm association" do end
shared_examples_for "asset association" do end
shared_examples_for "audio association" do end

shared_examples_for "set published at callback" do end

shared_examples_for "status methods" do end
shared_examples_for "publishing methods" do end

shared_examples_for "since scope" do end
