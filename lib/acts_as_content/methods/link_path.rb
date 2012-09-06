module ActsAsContent
  module Methods
    module LinkPath
      def self.included(base)
        if !base.instance_methods.include? :link_path
          # FIXMEL this gets run before the class is fully loaded so it fails.
          # raise "link_path not defined for #{base.name}."
        end
      end

      def remote_link_path
        "http://www.scpr.org#{self.link_path}"
      end
    end
  end
end
