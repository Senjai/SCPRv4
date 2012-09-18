## Shared Validations
# Model::Validations
#

def symbolize(klass)
  klass.to_s.underscore.to_sym
end

#---------------------------
# SlugValidation
shared_examples_for "slug validation" do
  context "should validate" do      
    before :each do
      described_class.any_instance.stub(:should_validate?) { true }
    end

    it { should validate_presence_of(:slug) }
    it { should validate_format_of(:slug).with(Model::Validations::DEFAULTS[:slug_format]) }
  end
  
  context "should not validate" do      
    before :each do
      described_class.any_instance.stub(:should_validate?) { false }
    end
    
    it { should_not validate_presence_of(:slug) }
    it { should_not validate_format_of(:slug) }
  end
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

#---------------------------
# ContentValidation
shared_examples_for "content validation" do
  context "should validate" do
    before :each do
      described_class.any_instance.stub(:should_validate?) { true }
    end
    
    it { should validate_presence_of :status }
    it { should validate_presence_of :headline }
    it { should validate_presence_of :body }
  end
  
  context "should not validate" do
    before :each do
      described_class.any_instance.stub(:should_validate?) { false }
    end
    
    it { should validate_presence_of :status }
    it { should validate_presence_of :headline }
    it { should_not validate_presence_of :body }
  end
end

#---------------------------
# SlugUniqueByPublishedAtValidation
# Also usable for other datetime fields
shared_examples_for "slug unique for date validation" do
  context "should validate" do      
    before :each do
      described_class.any_instance.stub(:should_validate?) { true }      
    end
    
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
  
  context "should not validate" do
    before :each do
      described_class.any_instance.stub(:should_validate?) { false }
    end
    
    it "does not validate slug uniqueness for date" do
      stub_publishing_callbacks(described_class)
    
      object1 = create symbolize(described_class), slug: "something", scope => Chronic.parse("Wednesday 8pm")
      object2 = build  symbolize(described_class), slug: "something", scope => Chronic.parse("Tuesday 8pm")
      object3 = build  symbolize(described_class), slug: "something", scope => object1.send(scope)

      object2.should be_valid
      object3.should be_valid
      object3.errors.keys.should be_empty
    end
  end
end

#---------------------------
# PublishedAtValidation
shared_examples_for "published at validation" do
  context "should validate" do
    before :each do
      described_class.any_instance.stub(:should_validate?) { true }      
    end
    
    it { should validate_presence_of(:published_at) }
  end
  
  context "should not validate" do
    before :each do
      described_class.any_instance.stub(:should_validate?) { false }      
    end
    
    it { should_not validate_presence_of(:published_at) }
  end
end
