module ActsAsContent
  module Methods
    module Comments
      def disqus_identifier
        if !self.respond_to? :obj_key
          raise "disqus_identifer needs obj_key. Missing from #{self.class.name}."
        end

        self.obj_key
      end

      def disqus_shortname
        API_KEYS["disqus"]["shortname"]
      end
    end
  end
end
