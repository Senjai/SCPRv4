module Secretary
  class Diff < Hash
    IGNORE = ["created_at", "updated_at"]
    
    # Simple wrapper around Diffy::Diff for Secretary support
    # Objects passed in should be Secretary::Version
    # version_b is required
    # version_a can be nil
    #
    def initialize(version_a, version_b)
      object_a = version_a.try(:frozen_object)
      object_b = version_b.frozen_object
      
      # If two real objects were passed in, they need to be the same class
      # Otherwise diffing them is pointless
      if object_a and object_a.class != object_b.class
        raise Secretary::Error::ClassMismatch, "Object classes must match to perform a diff"
      end
      
      # If object_a is nil, turn it into an empty hash
      object_a ||= {}
      
      # dup the attributes
      attributes = object_b.attributes
      
      # Drop attributes that we don't want to diff
      attributes.delete_if { |k, v| IGNORE.include? k }
      
      # Compare each of object_b's attributes to object_a's attributes
      # And if there is a difference, add it to the Diff
      attributes.each do |attribute, value|
        diff = Diffy::Diff.new(object_a[attribute].to_s, value.to_s)
        if diff.string1 != diff.string2
          self[attribute] = diff
        end
      end      
    end
  end
end
