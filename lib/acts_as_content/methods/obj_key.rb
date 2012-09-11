module ActsAsContent
  module Methods
    module ObjKey
      def obj_key
        if !self.class.const_defined?(:CONTENT_TYPE)
          raise "obj_key needs CONTENT_TYPE. Missing from #{self.class.name}."
        else
          [self.class::CONTENT_TYPE,self.id].join(":")
        end
      end
    end
  end
end
