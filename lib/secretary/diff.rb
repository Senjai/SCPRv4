module Secretary
  class Diff < Hash
    # Simple wrapper around Diffy::Diff for ActiveRecord support
    #
    def initialize(object_a, object_b)
      object_a.attributes.each do |attribute, value|
        diff = Diffy::Diff.new(value.to_s, object_b[attribute].to_s)
        if diff.string1 != diff.string2
          self[attribute] = diff
        end        
      end      
    end
  end
end
