require 'spec_helper'

describe Concern::Methods::AbstractModelMethods do
  describe '#==' do
    it 'is true if they are the same class and id is the same' do
      obj1 = AbstractModel.new(id: 1)
      obj2 = AbstractModel.new(id: 1)
      (obj1 == obj2).should eq true
    end

    it 'is false if the class is different' do
      obj1 = AbstractModel.new(id: 1)
      obj2 = Object.new

      (obj1 == obj2).should eq false
    end

    it 'is false if the ids are different' do
      obj1 = AbstractModel.new(id: 1)
      obj2 = AbstractModel.new(id: 2)
      (obj1 == obj2).should eq false
    end
  end

  describe '#cache_key' do
    it 'is the original object cache_key' do
      klass = Struct.new(:cache_key, :updated_at)
      person = klass.new("person:123", Time.now)
      obj = AbstractModel.new(original_object: person)
      obj.cache_key.should eq person.cache_key
    end

    it 'is nil if the original object does not have a cache key' do
      klass = Struct.new(:updated_at)
      person = klass.new(Time.now)
      obj = AbstractModel.new(original_object: person)
      obj.cache_key.should eq nil
    end
  end

  describe '#updated_at' do
    it 'is the original object updated_at' do
      klass = Struct.new(:cache_key, :updated_at)
      person = klass.new("person:123", Time.now)
      obj = AbstractModel.new(original_object: person)
      obj.updated_at.should eq person.updated_at
    end

    it 'is nil if the original object does no have a cache key' do
      klass = Struct.new(:cache_key)
      person = klass.new(Time.now)
      obj = AbstractModel.new(original_object: person)
      obj.updated_at.should eq nil
    end
  end


  describe '#created_at' do
    it 'is the original object created_at' do
      klass = Struct.new(:cache_key, :created_at)
      person = klass.new("person:123", Time.now)
      obj = AbstractModel.new(original_object: person)
      obj.created_at.should eq person.created_at
    end

    it 'is nil if the original object does no have a created_at' do
      klass = Struct.new(:cache_key)
      person = klass.new(Time.now)
      obj = AbstractModel.new(original_object: person)
      obj.created_at.should eq nil
    end
  end


  describe '#public_path' do
    it 'is the original object public_path' do
      klass = Struct.new(:cache_key) do
        def public_path(*args)
          "wat"
        end
      end

      person = klass.new("person:123")
      obj = AbstractModel.new(original_object: person)
      obj.public_path.should eq person.public_path
    end

    it 'is nil if the original object does no have a cache key' do
      klass = Struct.new(:cache_key)
      person = klass.new(Time.now)
      obj = AbstractModel.new(original_object: person)
      obj.public_path.should eq nil
    end
  end

end
